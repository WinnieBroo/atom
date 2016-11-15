=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

=cut

use 5.010;
use strict;
use warnings;
#use diagnostics;
use Data::Dumper;

use constant OPER => 1; 
use constant NUM => 2;
use constant UNAR => 3;
use constant OPBKT => 4;
use constant CLBKT => 5;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub tokenize {
	chomp(my $expr = shift);
	my @res;
	my @source = split m{((?<!e)[-+]|[*\(\)/^]|\s+)}, $expr;

	my $state = 0;
	my $cnt = 0; # counter of brackets

	for my $bang (@source) {
		given ($bang) {
			when (/^\s+$/) {};

			when (/^d*\.?\d+([e ][+-]?\d+)?$/) {
				unless ($state == NUM or $state == CLBKT) {push(@res, $bang); $state = NUM}
			};

			when (/[+-]/) {
				if ($state == NUM or $state == CLBKT) {push (@res, $bang); $state=OPER}
				else {push(@res,("U".$bang)); $state=UNAR;}
			};

			when (/[\*\/\^]/) {
				if ($state == NUM or $state == CLBKT) {push (@res, $bang); $state=OPER}
				else {die '$!'}
			};

			when ('(') {
				if ($state == 0 or $state == OPER or $state == UNAR) 
				{push (@res, $bang); $state=OPBKT; $cnt++}
			};

			when (')') {
				if ($state == NUM) {push (@res, $bang); $state=CLBKT; $cnt--}
				if ($cnt < 0) {die "Wrong count of brackets: '$expr'"}
			};

			default {
				die "Bad: ''";
			};
		}
	}

	unless ($state == NUM) {die "Wrong expression! '$expr'"};
	return \@res;

}

unless (caller) {
	use Data::Dumper;
	while (my $expression = <>) {
		next if $expression =~ /^\s+$/;
		print Dumper(tokenize($expression))
	}
}

1;
