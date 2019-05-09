#!/usr/bin/perl.orig-solaris10
 
#---------------------------------------
# MAIN ROUTINE
#---------------------------------------
# Display a menu and get a selection
get_menu_pick();

# as long as the E(x)it option is not chosen,
# execute the menu option and then display
# the menu again and ask for another choice
	
while ( $pick ne "x" )
{
	do_pick();
	get_menu_pick();
}
	
# clear the screen and exit with a 0 return code
clear_screen();
	
exit (0);
#---------------------------------------
# MAIN ROUTINE ENDS
#---------------------------------------
	
# Clear the screen, Show the menu and get user input
sub get_menu_pick
{
	clear_screen();
	print "*****************************************************\n";
	print "*    Eshop Weblogic Application Deployment Menu     *\n";
	print "*****************************************************\n";
	print "\n\n\n";
	show_menu();
	get_pick();
	}
	
# Clear the screen by printing 20 newlines
sub clear_screen
{
	for ($i=0; $i < 20; ++$i){
		print "\n";
	}
}
	
# Open menufile.txt or exit with an error
# read in each row picking up the first two fields by 
# splitting it on the pipe |
# print the first two fields
# send some form feeds to do some centering
sub show_menu
{
	$count = 0;
	open( MENUFILE, "menufile.txt") or die "Can't open menufile.txt: $!\n";
	while ($menurow=<MENUFILE>)
	{
		($menupick,$menuprompt)=split /:/,$menurow;
		print "\t$menupick\t$menuprompt \n";
		++$count;
	}
	close MENUFILE;
	print "\tx\tExit\n";
	++$count;
	$count = (24 - $count ) / 2;
	for ($i=0; $i < $count; ++$i){
		print "\n";
	}
	print "\n\nEnter your selection: ";
		
}
	
	# get user input and chop off the newline
sub get_pick()
{
		chomp($pick = <STDIN>);
}
	
sub do_pick()
{
	
open( MENUFILE, "menufile.txt") or die "Can't open menufile.txt: $!\n";
while ($menurow=<MENUFILE>)
{
	($menupick, $menuprompt, $menucommand)=split /:/,$menurow;
	if ($menupick eq $pick)
	{
		system $menucommand;
		break;
		}
		}
	close MENUFILE;
	press_enter();
}
	
# put up a message and wait for user to press ENTER
sub press_enter
{
#-	print "Press Enter to Continue . . .\n";
	print "Press Enter to Continue . . .\n";
		$dummy = <STDIN>;
}

