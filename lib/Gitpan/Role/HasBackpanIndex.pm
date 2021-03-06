package Gitpan::Role::HasBackpanIndex;

use perl5i::2;
use Method::Signatures;

use Mouse::Role;
use Gitpan::Types;

has backpan_index =>
  is            => 'rw',
  isa           => 'BackPAN::Index',
  lazy          => 1,
  builder       => "default_backpan_index";

# Everybody share one index object.
method default_backpan_index {
    require BackPAN::Index;
    state $index = BackPAN::Index->new;
    return $index;
}
