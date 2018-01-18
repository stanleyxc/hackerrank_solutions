<?php

function markers() {
    return array(
        '{' => '}',
        '(' => ')',
        '[' => ']'
    );
}
$buffer = array();
function right($str, $marker) {
    $markers = markers();
    if(empty($str)) return null;
    $c = substr($str, 0, 1); $str = substr($str,1);
    if($c === $marker) return $str;                               //first character is the bracket we wanted.
    if(in_array($c, array_values($markers), true)) return null;   //1st character is a closing bracket, but not the one we wanted.

    if($markers[$c]) {                                            //found another left bracket,
        $str = right($str, $markers[$c]);                         //initiate inner round search
        return ($str === null) ? null                             //inner round search failed
                               : right($str, $marker);            //succeeded - continue outter round match.
    }
    //other character...keep looking
    return right($str, $marker);
}
function braces($str) {
    $markers = markers();
    if(empty($str)) return 'YES';                                  //empty ok.
    $c = substr($str, 0, 1); $str = substr($str,1);

    if(in_array($c, array_values($markers))) return 'NO';          //found right bracket, bail out.
    if($markers[$c]) {                                             // left bracket, starting looking for closing bracket.
        $str = right($str, $markers[$c]);
        if(null === $str) return 'NO';                             //search failed.
    }
    return braces($str);                                           //other character...keep looking
}

$handle = fopen ("php://stdin","r");
fscanf($handle,"%d",$t);
for($a0 = 0; $a0 < $t; $a0++){
    fscanf($handle,"%s",$s);
    print braces($s) . "\n";
}

?>
