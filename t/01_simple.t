use strict;
use warnings;
use utf8;
use Test::More;
use Test::Requires 'Text::Xslate', 'Email::MIME';
use Encode;
use Holsten::Email::Simple::Tiffany::Japanese;

my $e = Holsten::Email::Simple::Tiffany::Japanese->new(
    'Text::Xslate' => {
        path => './t/tmpl/',
        syntax => 'TTerse',
    },
);

{
    my $mail = Email::MIME->new($e->render('foo.eml', {name => 'たろう', token => 'XZY'})->as_string);
    is $mail->header('Subject'), 'たろう様こんにちは';
    my $body = decode('iso-2022-jp', $mail->body);
    is $body, "よろしくね\015\012http://example.com/token=XZY\015\012";
}

{
    my $mail = Email::MIME->new($e->render('bar.eml', {name => 'たろう', token => 'XZY'})->as_string);
    my $body = decode('iso-2022-jp', $mail->body);
    is $body, "その2\015\012です。\015\012";
}

done_testing;
