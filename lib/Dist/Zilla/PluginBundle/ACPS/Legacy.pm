package Dist::Zilla::PluginBundle::ACPS::Legacy;

use Moose;
use 5.010001;

# ABSTRACT: Dist::Zilla ACPS bundle for dists not originally written with Dist::Zilla in mind
# VERSION

extends 'Dist::Zilla::PluginBundle::ACPS';

use namespace::autoclean;

around plugin_list => sub {
  my $orig = shift;
  my $self = shift;
  
  my @list = grep { (ref $_ ? $_->[0] : $_) !~ /^(Meta(YAML|JSON)|Readme|ModuleBuild|Manifest|PodWeaver|NextRelease|AutoPrereqs|OurPkgVersion)$/ } $self->$orig(@_);
  push @list, 'ACPS::Legacy';
  @list;
};

sub is_legacy { 1 }

sub allow_dirty { [ qw( dist.ini META.yml META.json ) ] };

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 DESCRIPTION

This plugin bundle is identical to L<@ACPS|Dist::Zilla::PluginBundle::ACPS> except it does not include
L<Manifest|Dist::Zilla::Plugin::Manifest>,
L<MetaYAML|Dist::Zilla::Plugin::MetaYAML>,
L<MetaJSON|Dist::Zilla::Plugin::MetaJSON>,
L<Readme|Dist::Zilla::Plugin::Readme>,
L<NextRelease|Dist::Zilla::Plugin::NextRelease>,
L<AutoPrereqs|Dist::Zilla::Plugin::AutoPrereqs>,
L<ModuleBuild|Dist::Zilla::Plugin::ModuleBuild> or
L<MakeMaker|Dist::Zilla::Plugin::MakeMaker>, as these are usually maintained by hand or via the Build.PL
in older ACPS distributions.

This plugin bundle also includes L<ACPS::Legacy|Dist::Zilla::Plugin::ACPS::Legacy>.

=cut
