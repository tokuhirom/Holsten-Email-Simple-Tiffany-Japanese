use inc::Module::Install;
name 'Holsten-Email-Simple-Tiffany-Japanese';
all_from 'lib/Holsten/Email/Simple/Tiffany/Japanese.pm';

requires 'Email::Simple';
requires 'Email::Date::Format';
requires 'Encode';
requires 'Tiffany';

test_requires 'Test::Requires';

readme_markdown_from 'lib/Holsten/Email/Simple/Tiffany/Japanese.pm';
tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More' => 0.96; # done_testing, subtest
author_tests('xt');
WriteAll;

