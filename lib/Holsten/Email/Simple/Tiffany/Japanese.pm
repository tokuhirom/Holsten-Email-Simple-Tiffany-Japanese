package Holsten::Email::Simple::Tiffany::Japanese;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.01';
use Tiffany;
use Encode ();
use Email::Simple;
use Email::Simple::Creator;

sub new {
    my ( $class, $name, $args ) = @_;
    my $tiffany = Tiffany->load( $name, $args );
    return bless { tiffany => $tiffany }, $class;
}

sub render {
    my ( $self, $tmpl, $args ) = @_;

    my @lines = split /\n/, $self->{tiffany}->render( $tmpl, {%$args} );
    my @headers;
    while ( @lines > 0 && $lines[0] =~ /^([A-Z][A-Za-z_-]+)\s*:\s*(.+?)$/ ) {
        my ( $key, $val ) = ( $1, $2 );
        push @headers, $key, Encode::encode( 'MIME-Header-ISO_2022_JP', $val );
        shift @lines;
    }
    if ( @lines > 0 && $lines[0] =~ /^\s*$/ ) {
        shift @lines;
    }
    my $body = Encode::encode( 'iso-2022-jp', join( "\n", @lines ) );

    return Email::Simple->create(
        header     => \@headers,
        body       => $body,
        attributes => {
            content_type => 'text/plain',
            charset      => 'ISO-2022-JP',
            encoding     => '7bit',
        },
    );
}

1;
__END__

=encoding utf8

=head1 NAME

Holsten::Email::Simple::Tiffany::Japanese - 日本語でメールを送信するときに楽するライブラリ

=head1 SYNOPSIS

    use Holsten::Email::Simple::Tiffany::Japanese;
    use Email::Sender::Simple qw/sendmail/;

    my $estj = Holsten::Email::Simple::Tiffany::Japanese->new(
        'Text::Xslate' => {
            syntax => 'TTerse',
            path   => ['./email_tmpl/'],
        },
    );
    my $email = $estj->render('foo.eml', {token => $token});
    sendmail($email);

=head1 DESCRIPTION

日本語でメールを送信できます。

テンプレートファイルには

    Subject: [% name %]様へお特な情報のご案内

    おとくですよ！
    http://example.com[% path_info %]

のようにかくことができます。

最初のヘッダ行はなくてもかまいません。

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
