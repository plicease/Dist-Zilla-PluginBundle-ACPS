package Dist::Zilla::Plugin::ACPS::Mint;

use Moose;
use 5.010001;
use Git::Wrapper;

# ABSTRACT: init plugin for ACPS
# VERSION

with 'Dist::Zilla::Role::AfterMint';
with 'Dist::Zilla::Role::FileGatherer';

use namespace::autoclean;

sub after_mint
{
  my($self, $opts) = @_;

  my $git = Git::Wrapper->new($opts->{mint_root});

  foreach my $remote ($git->remote('-v'))
  {
    # TODO maybe also create the cm repo remote
    if($remote =~ /^public\s+(.*):(public_git\/.*\.git) \(push\)$/)
    {
      my($hostname,$dir) = ($1,$2);
      use autodie qw( :system );
      system('ssh', $hostname, 'git', "--git-dir=$dir", 'init', '--bare');
      $git->push(qw( public master ));
    }
  }

}

sub gather_files
{
  my($self, $arg) = @_;
  $self->gather_file_travis_yml($arg);
}

sub gather_file_travis_yml
{
  my($self, $arg) = @_;

  my $file = Dist::Zilla::File::InMemory->new({
    name    => '.travis.yml',
    content => join("\n", q{language: perl},
                          q{},
                          q{#install:},
                          q{#  - cpanm -n Foo::Bar},
                          q{},
                          q{perl:},
                          (map { "  - \"5.$_\""} qw( 10 12 14 16 18 )),
                          q{},
                          q{#before_script: /bin/true},
                          q{},
                          q{script: HARNESS_IS_VERBOSE=1 prove -lv t xt},
                          q{},
                          q{#after_script: /bin/true},
                          q{},
                          q{branches:},
                          q{  only:},
                          q{    - master},
                          q{},
    ),
  });

  $self->add_file($file);

}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 DESCRIPTION

Standard init plugin for ACPS distros.

=cut
