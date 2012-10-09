package Dist::Zilla::App::Command::apspec;

# forked from Dist::Zilla::App::Command::mkrpmspec

use strict;
use warnings;
use Carp;
use File::HomeDir;

# ABSTRACT: generate RPM spec file from your template
our $VERSION = '0.08'; # VERSION

use Dist::Zilla::App -command;

sub abstract { 'generate RPM spec file from your build template' }

sub execute {
    my($self,$opt,$args) = @_;
    my($filename) = @{$args};

    require Path::Class;

    $_->before_build     for @{ $self->zilla->plugins_with(-BeforeBuild) };
    $_->gather_files     for @{ $self->zilla->plugins_with(-FileGatherer) };
    $_->prune_files      for @{ $self->zilla->plugins_with(-FilePruner) };
    $_->register_prereqs for @{ $self->zilla->plugins_with(-PrereqSource) };

    $filename ||= $self->zilla->name . '.spec';

    my $outfile = Path::Class::File->new(File::HomeDir->my_home, qw( rpmbuild SPECS ), $filename);
    my $out = $outfile->openw;
    
    my $plugin = $self->zilla->plugin_named('ACPS::RPM');
    
    unless(defined $plugin)
    {
        $self->log("[apspec] add this to your dist.ini:");
        $self->log("[apspec] [ACPS::RPM]");
        $self->log("[apspec] ;ignore_build_deps = 1 ; uncomment to ignore deps");
        die "could not find ACPS::RPM plugin";
    }
    
    print $out $plugin->mk_spec(
        sprintf('%s-%s.tar.gz',$self->zilla->name,$self->zilla->version),
        $outfile,
    );
}

1;


__END__
=pod

=head1 NAME

Dist::Zilla::App::Command::apspec - generate RPM spec file from your template

=head1 VERSION

version 0.08

=head1 SYNOPSIS

  dzil apspec [filename]

=head1 DESCRIPTION

This command writes a parsed version of the spec file that would be generated by
L<Dist::Zilla::Plugin::RPM|Dist::Zilla::Plugin::RPM> during release, without
having to do a full release. This is useful for testing or tweaking your RPM
build without having to run dzil each time.

=head1 EXAMPLE

  $ dzil apspec
  $ dzil apspec /path/to/foo.spec

=head1 OPTIONS

=head2 filename (default: "./dzil.spec")

The filename to write the specfile to.

=head1 AUTHOR

Graham Ollis <gollis@sesda2.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by NASA GSFC.  No
license is granted to other entities.

=cut

