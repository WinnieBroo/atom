=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
#use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub priority {
	my $operation = shift;
	given ($operation) {
		when (['U+','U-']) {return 4;}
		when (['^']) {return 3;}
		when (['*','/']) {return 2;}
		when (['+','-']) {return 1;}
		default {return 0;}
	}
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @rpn;
	my @operation;

	for my $foo (@{$source}) {
		
		given ($foo) {
			
			when (['+','-','*','/','U+','U-','^']) {
				if ($foo =~ /U[\+\-]|\^/) {
					while (priority($foo) < priority($operation[-1])) {
						push(@rpn, pop(@operation))
					}
				} else {
					while (priority($foo) <= priority($operation[-1])) {
						push(@rpn, pop(@operation))
					}
				}
				push(@operation, $foo)
			}
			
			when ('(') {
				push(@operation, $foo)
			}

			when (')') {
				while ($operation[-1] ne '(') {
					if (@operation) {push(@rpn, pop(@operation))}
					else {die "Incorrect brackets"}
				}
				pop(@operation)
			}

			default {
				$foo = 0 + $foo;
				push(@rpn, pop(@operation))
				}
			}

		}

	while (@operation and $operation[-1] ne '(') {		
		push (@rpn, pop(@operation));
	};

	if (@operation) {die "Wrong expression"};

	return \@rpn;

};

1;
