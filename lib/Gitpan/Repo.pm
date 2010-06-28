use MooseX::Declare;

class Gitpan::Repo {
    use perl5i::2;
    use Path::Class;
    use Gitpan::Types qw(Distname AbsDir);
    use MooseX::AlwaysCoerce;

    use overload
      q[""]     => method { return $self->distname },
      fallback  => 1;

    has distname        => 
      isa       => Distname,
      is        => 'ro',
      required  => 1
    ;

    has directory       =>
      isa       => AbsDir,
      is        => 'rw',
      required  => 1,
      lazy      => 1,
      default   => method {
          require Path::Class::Dir;
          return Path::Class::Dir->new($self->distname)->absolute;
      }
    ;

    has git     =>
      isa       => "Gitpan::Git",
      is        => 'rw',
      required  => 1,
      lazy      => 1,
      coerce    => 0,
      default   => method {
          require Gitpan::Git;
          return Gitpan::Git->create( init => $self->directory);
      };

    has github  =>
      isa       => 'Gitpan::Github',
      is        => 'rw',
      required  => 1,
      lazy      => 1,
      coerce    => 0,
      default   => method {
          require Gitpan::Github;
          return Gitpan::Github->new(
              repo      => $self->distname,
          );
      };

    method exists_on_github() {
        # Optimization, asking github is expensive
        return 1 if $self->git->remote("origin") =~ /github.com/;
        return $self->github->exists_on_github( $self->repo );
    }

    method note(@args) {
        # no op for now
    }
}
