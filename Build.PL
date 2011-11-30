
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Slurp" => 0,
    "Module::Build" => "0.3601",
    "Test::Fatal" => 0,
    "Test::More" => "0.88"
  },
  "configure_requires" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "abstract implementation of the bittorrent p2p protocol",
  "dist_author" => [
    "Tom Molesworth <cpan\@entitymodel.com>"
  ],
  "dist_name" => "Protocol-BitTorrent",
  "dist_version" => "0.003",
  "license" => "perl",
  "module_name" => "Protocol::BitTorrent",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Convert::Bencode_XS" => "0.06",
    "Digest::SHA" => "5.63",
    "HTTP::Message" => 0,
    "Try::Tiny" => "0.11",
    "URI" => 0,
    "URI::QueryParam" => 0,
    "parent" => 0
  },
  "script_files" => [
    "bin/torrentcreate.pl",
    "bin/torrentedit.pl"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
