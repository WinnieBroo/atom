=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub evaluate {
	my $rpn = shift;
	my @stack;
	for my $foo (@{$rpn}){
		given ($foo) {
			when (/[+-\*\/\^]/){
				my $x = pop(@stack);
				my $y = pop(@stack);
				given ($foo) {
					when ("*") {push (@stack, $x * $y)}
					when ("/") {push (@stack, $x / $y)}
					when ("-") {push (@stack, $x - $y)}
					when ("+") {push (@stack, $x + $y)}
					when ("^") {push (@stack, $x ^ $y)}
				}
			}
			when (['U+', 'U-']) {
				if ($foo eq 'U-') { my $x = pop(@stack); push(@stack, -$x)}
			}
			default{
				push(@stack);
			}
		}
	}

	return pop(@stack);
}

1;
