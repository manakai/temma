package Temma::Defs;
use strict;
use warnings;
our $VERSION = '1.0';
use Whatpm::HTML::Defs;
use Whatpm::HTML::ParserData;
use Exporter::Lite;

our @EXPORT = qw(HTML_NS MML_NS SVG_NS TEMMA_NS XML_NS XMLNS_NS XLINK_NS);

sub HTML_NS (); *HTML_NS = \&Whatpm::HTML::ParserData::HTML_NS;
sub SVG_NS (); *SVG_NS = \&Whatpm::HTML::ParserData::SVG_NS;
sub MML_NS (); *MML_NS = \&Whatpm::HTML::ParserData::MML_NS;
sub XML_NS (); *XML_NS = \&Whatpm::HTML::ParserData::XML_NS;
sub XMLNS_NS (); *XMLNS_NS = \&Whatpm::HTML::ParserData::XMLNS_NS;
sub XLINK_NS (); *XLINK_NS = \&Whatpm::HTML::ParserData::XLINK_NS;
sub TEMMA_NS () { q<http://suika.fam.cx/www/markup/temma> }

my @metavoid = qw(
  link meta base basefont bgsound command
  t:attr t:wait t:call
);
my @metacontent = qw(
  title style script noscript
  t:element t:comment t:if
);
my @bodyvoid = qw(
  area br embed img keygen wbr input param source track hr image isindex
  col t:text t:elsif t:else
);

our $AutoOpen = {
  'html' => {
    '<text>' => 'body',
    'head' => '',
    'body' => '',
    '<start>' => 'body',
    (map { $_ => 'head' } @metavoid),
    (map { $_ => 'head' } @metacontent),
    't:attr' => '',
  },
  'table' => {
    'tr' => 'tbody',
  },
};

our $AutoClose = {
  head => {
    '<text>' => 1,
    '<start>' => 1,
    'head' => '',
    (map { $_ => '' } @metavoid),
    (map { $_ => '' } @metacontent),
  },
  tr => {
    thead => 1,
    tbody => 1,
    tfoot => 1,
  },
  th => {
    thead => 1,
    tbody => 1,
    tfoot => 1,
  },
  td => {
    thead => 1,
    tbody => 1,
    tfoot => 1,
  },
  colgroup => {
    thead => 1,
    tbody => 1,
    tfoot => 1,
    colgroup => 1,
    tr => 1,
  },
  option => {
    option => 1,
    optgroup => 1,
  },
  optgroup => {
    optgroup => 1,
  },
  rt => {
    rp => 1,
    rt => 1,
  },
  rp => {
    rp => 1,
    rt => 1,
  },
};

our $Void = {
  (map { $_ => 1 } @metavoid),
  (map { $_ => 1 } @bodyvoid),
};

our $RawContent = {
  script => SCRIPT_DATA_STATE,
  style => RAWTEXT_STATE,
  xmp => RAWTEXT_STATE,
  #iframe => RAWTEXT_STATE,
  #noframes => RAWTEXT_STATE,
  #noembed => RAWTEXT_STATE,
  #noscript => RAWTEXT_STATE,
  title => RCDATA_STATE,
  textarea => RCDATA_STATE,
  #plaintext
};

our $CloseIfInScope = {
  (map { $_ => {p => 1, body => -1} } qw(
    address article aside blockquote center details dialog dir div dl
    fieldset figcaption figure footer header hgroup menu nav ol
    section summary ul h1 h2 h3 h4 h5 h6 pre listing form plaintext
    form table hr isindex xmp
  )),
  p => {p => 1, body => -1},
  li => {li => 1, ol => -1, ul => -1, menu => -1, dir => -1, body => -1},
  dt => {dt => 1, dd => 1, dl => -1, body => -1},
  dd => {dt => 1, dd => 1, dl => -1, body => -1},
  'thead' => {'table' => 0},
  'tbody' => {'table' => 0},
  'tfoot' => {'table' => 0},
  'tr' => {'tr' => 1, 'table' => -1},
  'th' => {'th' => 1, 'td' => 1, 'table' => -1},
  'td' => {'th' => 1, 'td' => 1, 'table' => -1},
  't:else' => {'t:if' => 0},
  't:elsif' => {'t:if' => 0},
};

our $EndTagOptional = {
  p => 1,
  li => 1,
  dt => 1,
  dd => 1,
  tr => 1,
  th => 1,
  td => 1,
  thead => 1,
  tbody => 1,
  tfoot => 1,
  rt => 1,
  rp => 1,
  option => 1,
  optgroup => 1,
  colgroup => 1,
};

our $PreserveWhiteSpace = {
  (HTML_NS) => {
    pre => 1,
    xmp => 1,
    listing => 1,
    textarea => 1,
    style => 1,
    script => 1,
    plaintext => 1,
  },
  (SVG_NS) => {
    style => 1,
    script => 1,
  },
};

our $IgnoreFirstNewline = {
  pre => 1,
  listing => 1,
  textarea => 1,
};

1;

=head1 LICENSE

Copyright 2012 Wakaba <w@suika.fam.cx>.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
