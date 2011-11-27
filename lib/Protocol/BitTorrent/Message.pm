package Protocol::BitTorrent::Message;
{
  $Protocol::BitTorrent::Message::VERSION = '0.001';
}
use strict;
use warnings FATAL => 'all', NONFATAL => 'redefine';

use Protocol::BitTorrent::Message::Keepalive;
use Protocol::BitTorrent::Message::Choke;
use Protocol::BitTorrent::Message::Unchoke;
use Protocol::BitTorrent::Message::Interested;
use Protocol::BitTorrent::Message::Uninterested;
use Protocol::BitTorrent::Message::Have;
use Protocol::BitTorrent::Message::Bitfield;
use Protocol::BitTorrent::Message::Request;
use Protocol::BitTorrent::Message::Piece;
use Protocol::BitTorrent::Message::Cancel;
use Protocol::BitTorrent::Message::Port;

=head1 NAME

Protocol::BitTorrent::Message - base class for BitTorrent messages

=head1 VERSION

version 0.001

=head1 SYNOPSIS

 use Protocol::BitTorrent::Message;
 $sock->read(my $buf, 4096);
 while(my $msg = Protocol::BitTorrent::Message->new_from_buffer(\$buf)) {
 	$self->handle_message($msg);
 }

=head1 DESCRIPTION

See L<Protocol::BitTorrent> and L<Protocol::BitTorrent::Metainfo> for
usage information.

=cut

=head1 METHODS

=cut

=head2 new

Base method for instantiation, returns a blessed object.

=cut

sub new {
	my $self = bless {}, shift;
	$self;
}

=head2 new_from_buffer

Returns an instance of a L<Protocol::BitTorrent::Message> subclass, or undef if
insufficient data has been provided in the buffer.

Takes a single scalar ref as parameter - this should be a reference to the scalar
buffer containing data to be parsed. Removes packet data from this buffer if
parsing was successful.

=cut

sub new_from_buffer {
	my $class = shift;
	my $buffer = shift;
	return undef unless defined $buffer && length $$buffer >= 4;

# First item is the length (excluding 4-byte length field)
	my ($len) = unpack 'N1', substr $$buffer, 0, 4, '';

# Keepalive messages just contain the 4-byte length, no other data
	return Protocol::BitTorrent::Message::Keepalive->new unless $len--;

	my ($type_id) = unpack 'C1', substr $$buffer, 0, 1, '';
	my $class_name = $class->class_name_by_type($type_id)
		or die sprintf "Invalid type [%02x] detected", $type_id;

	return $class_name->new_from_data($len ? substr $$buffer, 0, $len, '' : '');
}

{

my %type_map = (
	0 => 'choke',
	1 => 'unchoke',
	2 => 'interested',
	3 => 'uninterested',
	4 => 'have',
	5 => 'bitfield',
	6 => 'request',
	7 => 'piece',
	8 => 'cancel',
	9 => 'port',
);

=head2 class_name_by_type

Returns the class name for the given type (as taken from a BitTorrent network packet).

=cut

sub class_name_by_type {
	my ($self, $type) = @_;
	return __PACKAGE__ . '::' . ucfirst $type_map{$type};
}

}

=head2 as_string

Returns a stringified version of this message.

=cut

sub as_string {
	my $self = shift;
	return sprintf '%s, %d bytes', $self->type, $self->packet_length;
}

sub packet_length { 0 }

=head2 type

Returns the type for this message - stub method for base class, should be overridden
in subclasses.

=cut

sub type { 'unknown' }

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2011. Licensed under the same terms as Perl itself.
