cat perl.txt | perl -naF';' -E 'BEGIN {$iter=0}; if ($F[4]>1024) {$iter++; print $_}; END{print "Total:$.\nExpr:$iter\n"}'