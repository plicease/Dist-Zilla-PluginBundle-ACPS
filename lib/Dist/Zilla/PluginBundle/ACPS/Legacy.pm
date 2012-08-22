package Dist::Zilla::PluginBundle::ACPS::Legacy;

use Moose;
use v5.10;

# ABSTRACT: Dist::Zilla ACPS bundle for dists not originally written with Dist::Zilla in mind
our $VERSION = '0.06'; # VERSION

extends 'Dist::Zilla::PluginBundle::ACPS';

use namespace::autoclean;

sub plugin_list {
  qw(
    GatherDir
    PruneCruft
    ManifestSkip
    License
    ExtraTests
    ExecDir
    ShareDir

    TestRelease
    ConfirmRelease
    ACPS::Release
    ACPS::Legacy

    PodVersion
    AutoPrereqs
    OurPkgVersion
  )
}

sub is_legacy { 1 }

sub allow_dirty { [ qw( dist.ini META.yml META.json ) ] };

__PACKAGE__->meta->make_immutable;

1;



=pod

=head1 NAME

Dist::Zilla::PluginBundle::ACPS::Legacy - Dist::Zilla ACPS bundle for dists not originally written with Dist::Zilla in mind

=head1 VERSION

version 0.06

=head1 DESCRIPTION

This plugin bundle is identical to L<@ACPS|Dist::Zilla::PluginBundle::ACPS> except it does not include
L<Manifest|Dist::Zilla::Plugin:::Manifest>,
L<MetaYAML|Dist::Zilla::Plugin::MetaYAML>,
L<MetaJSON|Dist::Zilla::Plugin::MetaJSON>,
L<Readme|Dist::Zilla::Plugin::Readme>,
L<NextRelease|Dist::Zilla::Plugin::NextRelease>,
L<ModuleBuild|Dist::Zilla::Plugin::ModuleBuild> or
L<MakeMaker|Dist::Zilla::Plugin::MakeMaker>, as these are usually maintained by hand or via the Build.PL
in older ACPS distributions.

This plugin bundle also includes L<ACPS::Legacy|Dist::Zilla::Plugin::ACPS::Legacy>.

=head1 AUTHOR

Graham Ollis <gollis@sesda2.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by NASA GSFC.  No
license is granted to other entities.

=cut


__END__
