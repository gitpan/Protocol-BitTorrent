package Protocol::BitTorrent;
# ABSTRACT: abstract implementation of the bittorrent p2p protocol
use strict;
use warnings FATAL => 'all', NONFATAL => 'redefine';
use parent qw(Protocol::BitTorrent::Bencode);

our $VERSION = '0.001';

=head1 NAME

Protocol::BitTorrent - protocol-level support for BitTorrent and .torrent files

=head1 VERSION

version 0.001

=head1 SYNOPSIS

 package BitTorrent::Implementation;
 use Protocol::BitTorrent;
 ...

=head1 DESCRIPTION

This distribution provides handling for the BitTorrent protocol at an abstract
level. Although some utilities are provided for dealing with .torrent files,
the intention is for this class to act as a base for building BitTorrent
client/server/tracker implementations, rather than a complete independent package.
Specifically, no attempt is made to listen or connect to network sockets.

See L<Protocol::BitTorrent::Metainfo> for information on dealing with
.torrent files, and also check the C< examples/ > and C< bin/ > directories
for examples of code using these classes.

An actual working client+tracker implementation can be found in
L<Net::Async::BitTorrent>.

=cut

use Protocol::BitTorrent::Metainfo;

use Convert::Bencode_XS qw();
use Try::Tiny;

=head1 METHODS

=cut

=head2 new

=cut

sub new { bless {}, shift }

=head2 parse_metainfo

Parse .torrent data and return a L<Protocol::BitTorrent::Metainfo> instance.

=cut

sub parse_metainfo {
	my $self = shift;
	my $encoded = shift;

	my $decoded = try {
		$self->bdecode($encoded);
	} catch {
		# Ensure we have a recognisable string at the start of the error message
		die "Parse error: $_\n";
	};
	return Protocol::BitTorrent::Metainfo->new->parse_info($decoded);
}

=head2 generate_metainfo

Wrapper around L<Protocol::BitTorrent::Metainfo> for creating new .torrent data.

=cut

sub generate_metainfo {
	my $self = shift;
	my %args = @_;
	return Protocol::BitTorrent::Metainfo->new(%args);
}

1;

__END__

=head1 SEE ALSO

=over 4

=item * L<Net::BitTorrent> - seems to be a solid implementation of the
protocol, at time of writing was undergoing some refactoring to switch
to L<Moose> and L<AnyEvent> although development appears to have stalled
for the last year.

=item * L<http://wiki.theory.org/BitTorrentSpecification> - 'unofficial'
spec.

=item * L<http://en.wikipedia.org/wiki/Comparison_of_BitTorrent_tracker_software> - a
list of other BitTorrent software, this list is likely to be more up to
date than this section.

=back

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2011. Licensed under the same terms as Perl itself.
