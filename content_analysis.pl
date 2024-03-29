#!/usr/bin/env perl
use v5.14;
use strict;
use warnings;
use Statistics::Lite qw( mean );
use List::Util qw( min max sum0 );
use Config::Tiny;
use Data::Dumper qw(Dumper);
use File::HomeDir;
use Term::ANSIColor;
use Scalar::Util 'blessed';
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use Switch;

my $home	= File::HomeDir->my_home;
my $Config 	= Config::Tiny->new;

# reading path strings
$Config	= Config::Tiny->read("$home/PPT-Dread/asset_paths.conf");
	my $status_path		= $Config->{paths}->{status};
	my $modules_path 	= $Config->{paths}->{modules};
	my $em_path 		= $Config->{paths}->{em};
	my $text_data		= $Config->{paths}->{text_data};
	my $source_path		= $Config->{paths}->{source_path};

#custom modules
use lib dirname(dirname abs_path $0) . '/PPT-Dread';
use Grouping_zero qw( create_grouping_zero_v create_grouping_zero_o );
use GroupingA qw( create_groupingAv create_groupingAo );
use GroupingB qw( create_groupingBv create_groupingBo );
use GroupingC qw( create_groupingCv create_groupingCo );
use GroupingD qw( create_groupingDv create_groupingDo );
use GroupingE qw( create_groupingEv create_groupingEo );
use GroupingF qw( create_groupingFv create_groupingFo );
use GroupingG qw( create_groupingGv create_groupingGo );
use GroupingH qw( create_groupingHv create_groupingHo );
use GroupingI qw( create_groupingIv create_groupingIo );
# getting tweet file
my $tweet	= "$home/$text_data/trumptweet.txt"; 

my $row			= undef;
open(my $fh, '<:encoding(UTF-8)', $tweet)
  or die "Could not open file '$tweet' $!";
my $tweet_txt_0 = <$fh>;
my $tweet_txt = undef;
my $space = " ";
# filehandles
my (
	$Hf	,
	$Hf0	,
	$Hf1	,
	$Hf2	,	
	) = undef;

# counting scalars
my $dread_result 	=0;
my $boast_result 	=0;
my $insult_result 	=0;

my $svg_txt1="$text_data/textVI.txt";
open( $Hf, '>', "$home/$svg_txt1")
or die "Could not open file ' textfile VI'";
binmode $Hf, ':encoding(UTF-8)';
		
print"\ncontent_analysis.pl\n";	
close $Hf;

#title
print color('bold white');
print"\n 	~ CONTENT ANALYSIS ~\n";
print color('reset');

#opening filehandles for report
	#declaration file
my $svg_txt2="$text_data/textVII.txt";
open( $Hf0, '>', "$home/$svg_txt2")
or die "Could not open file ' textfile VII'";
	#Analysis file
my $svg_txt3= "$home/$text_data/textX.txt";
open( $Hf1, '>', "$svg_txt3")
  or die "Could not open file '$svg_txt3' $!";
#print $Hf1

# pereparations - finding out the time at which the tweet was posted.
my @current_time = undef;
	#reading tweetstatus
sub read_details {
		# declaring configuartion file ->
		$Config	= Config::Tiny->read("$home/$status_path");
		
		# reading essential vaulues
		@current_time =split /-/,$Config->{class}->{month};
};
read_details;

#cleaning tweet, here special characters are removed and all capital letters are converted to lower case to facilitate comparison tith the grouping modules
	$tweet_txt = join("", " ", $tweet_txt_0, " ");
	$tweet_txt  =~ s/\R//g;print ">$tweet_txt< \n";
	print "\nstripping obstructive characters\n";
	$tweet_txt =~ tr/!?&'"#()[]{}-–”“~*;,:.%@=/ /;
	print "lower case all\n";
	$tweet_txt = lc $tweet_txt;
	close $Hf0;

open(my $processed_tweet, '>', "$home/$text_data/processed_tweet.txt");
print "$text_data/processsed_tweet.txt\n";
truncate $processed_tweet, 0;
close $processed_tweet;

open(my $processed_tweet, '>>', "$home/$text_data/processed_tweet.txt");
print $processed_tweet "$tweet_txt\n";
close $processed_tweet;


#setting up various findings arrays
my @evaluation 	= (["Grouping_zero"],["GroupingA"],["GroupingB"],["GroupingC"],["GroupingD"],["GroupingE"],["GroupingF"],["GroupingG"],["GroupingH"],["GroupingI"]);
my @findings 	= (["Grouping_zero"],["GroupingA"],["GroupingB"],["GroupingC"],["GroupingD"],["GroupingE"],["GroupingF"],["GroupingG"],["GroupingH"],["GroupingI"]);
my @finding_data = ("word", "wordtype", "sig", "func", "stat", "relevant_time", "unique_source");

	my @objects;
	my $objects;
	my $objects_ref;
	my $values_ref;
	
my (	
	$current_grouping	,
	$irrelevance	,
	$active_time	,
	$grouping_displayed	,
	$countI	,
	$standard_incidence_count	,
		$test_counter	,
		$irrelevance_count	,
		$insult_count	,
		$complaint_count	,
		$boast_count	,
	) = undef;
	
$active_time 				= 1; #on by default ...
$grouping_displayed 		= 0;
$test_counter				= 0;
$irrelevance_count			= 0;
$insult_count 				= 0;
$boast_count 				= 0;
$complaint_count 			= 0;
$standard_incidence_count 	= 0;

my @g_l = ('A'..'I');
my @g_l_val = (0,1,0,1,0,0,1,1,1); #high priority groupings
my @g_c_val = (0,0,0,0,0,0,0,0,0); #special priority for climate grouping - if needed - seems to be unnecessary

my @modifyers = (0, 1.51, 1.81, 1.76, 1.84, 1.71, 1.51, 1.91, 1.87, 1.57); #8;
my @zero_modifyers = (1.57, 1.41, 1.31); # insult, complaint, boast

my %weight_distr;
my %grouping_positions;

#initializing mutidimensional hash array
my $countnow = 0;
foreach my $vlaues (@g_l_val){
	$weight_distr {$g_l[$countnow]} = $g_l_val[$countnow];
	$countnow++;
	}
$countnow = 1;
foreach my $vlaues0 (@g_l){
	$grouping_positions {$g_l[$countnow-1]} = $countnow;
	$countnow++;
	}
$countnow = 0;

my @mentioned_groupings;  # contains all groupings that were mentioned in grouping Zero.
my %mentioned_groupings_count;

$countnow = 1;
foreach my $vlaues1 (@g_l){
	$mentioned_groupings_count {$g_l[$countnow-1]} = 0;
	$countnow++;
	}
$countnow = 0;

my %grouping_incidence; #counter for number of findings per grouping - may be redundant.

#this subroutine matches the active grouping against the Tweet text.
sub standard_test {

	$grouping_displayed=0;
	$standard_incidence_count = 0;
	foreach $objects (@{$objects_ref}) {
		
		#defining temporary values
		my $object_number= scalar(@{$objects});
		my $object_words= ($object_number-1);
		my $countI 		= 1;
		my $countII 	= 0;
		my $grouping_zero_result = 0;
		my $grouping_zero_finding 	= undef;
		my $temp_active 	= undef;
		
		#while loop for each grouping
		while ( $countI <= $object_words){
			$temp_active	= 0;	
			my $active_word = ${$objects}[$countI][0];
			#looking for match
			
			# additional ifclause required here that testst first character in string and if it is empty space and a noun or name, uses it as an aditional matching option - if defined match word twice...
			# if ($active_word =~ m/$active_word/){};
			
			
			if ( $tweet_txt =~ m/$active_word/) {
				
				#testing if relevant time period is defined
				if (${$objects}[$countI][5] eq "null") {
					$active_time = 1;
				}
				else {
					#deactivating time relevance indicator
					$active_time = 0;
					#creating timespan array
					my @timespan = 		split /:/, ${$objects}[$countI][5];
					#testing timespan
					if ($current_time[1] >= $timespan[1] && $current_time[1] <= $timespan[3]) {
						
						if ($current_time[1] == $timespan[1] && $current_time[1] == $timespan[3]) {
							if ($current_time[0] >= $timespan[0]) {
								unless ($timespan[2]<$current_time[0]) {
									$active_time = 1;
									$temp_active = 1;
								}
							}
						}
						elsif ($current_time[1] == $timespan[3]) {
							if ($current_time[0] <= $timespan[2]) {
								$active_time = 1;
								$temp_active	= 1;
							}
						}
						else {
							$active_time = 1;
							$temp_active = 1;
						};
					
					};
				};
				
				#if currently relevant, saving findings hash into mutidimensional array 
				if ($active_time == 1) {	
					if ($grouping_displayed == 0){
						print "\n\n Grouping_$current_grouping \n";
						print $Hf1 "\n\n Grouping_$current_grouping \n";
						$grouping_displayed =1;
					};

					#writing results to file
					 print "	${$objects}[0][1]:";
					print $Hf1  "	${$objects}[0][1]:";
					 print color('bold white');
					 print uc " '$active_word' \n";
					print  $Hf1 uc" '$active_word' \n";
					 print color('reset');
					
					#creating findings hash
					my %current_findings = ("timesensitive" => $temp_active, "object" => ${$objects}[0][1], "relevance" => ${$objects}[0][2], "standard_source" => ${$objects}[0][3], "escalated_source" => ${$objects}[0][4]);
					
					#populating hash
					while ( $countII <= 6){
						$current_findings {$finding_data[$countII]} = ${$objects}[$countI][$countII];
						$countII++;
					};
					
					my $current_findings_ref = \%current_findings;
					 #$grouping_zero_finding = \@{@{$objects}[$countI]};
					
					#pushing hach in to array
					push(@{$findings[$test_counter]}, $current_findings_ref);
					$grouping_zero_result++;
					
					#checking for irrelevance value and setting grouping incidence;
					#$test_groupings {$loop_result} = $currnent_grouping;

					if ($current_grouping eq "zero") {
						if(${$objects}[0][1] eq 'irrelevant') {
							$irrelevance_count ++;
						}
						elsif(${$objects}[0][1] eq 'insult')	{
							$insult_count ++;
							}
						elsif(${$objects}[0][1] eq 'boast')		{
							$boast_count ++;
							}
						elsif(${$objects}[0][1] eq 'complaint')	{
							$complaint_count ++;
							}
						else{};
					}
					else {
					$standard_incidence_count++;
					#print "incidence_count active!\n"
					}
					
					if($test_counter==0) {
						
						my $grouping_indicatior = $current_findings {"stat"};
						unless ($grouping_indicatior eq "null") {
							
							my $mention_count =	$mentioned_groupings_count {$grouping_indicatior};
							#print "$mention_count\n";

							if ($mention_count == 0) {
								push @mentioned_groupings, $grouping_positions {"$grouping_indicatior"};	
							};
							
							$mention_count++;
							$mentioned_groupings_count {$grouping_indicatior} = $mention_count;
							
							print "	[", $grouping_indicatior, "]";
						};
					};
					
				}
				#incase of inactive timeperiod
				else {
					if ($grouping_displayed == 0){
						print "\n\n Grouping_$current_grouping \n";
						print $Hf1 "\n\n Grouping_$current_grouping \n";
						$grouping_displayed =1;	
						
					};
					print "	",${$objects}[0][1],": '",uc $active_word,"' [0]\n";
					print $Hf1 "	",${$objects}[0][1],": '",uc $active_word,"' [0]\n";
				};
			};
			$countII=0;
			$countI++;
		};
	};
	$test_counter++;
	#print "\ngrouping incidence =$standard_incidence_count\n";

};
my $active_mod = undef;

sub match_groupings {
	
	#Grouping Zero - insult, boast, complaint and irrelevancy signifyers
		$current_grouping = "zero";
			#values not relevant here.
		#$values_ref=\@Grouping_zero::values_zero;
		$objects_ref=\@Grouping_zero::objects_zero;
			#create_grouping_zero_v;
		create_grouping_zero_o;
		standard_test;
		$grouping_incidence {'irrelevant'} 	= $irrelevance_count; 
		$grouping_incidence {'insult'} 		= $insult_count; 
		$grouping_incidence {'boast'} 		= $boast_count; 
		$grouping_incidence {'complaint'} 	= $complaint_count; 
		
	#GroupingA - war, the military and the nuclear threat
		$active_mod = $modifyers[0];
		$current_grouping = "A";
			#objects not relevant here.
		#$objects_ref=\@GroupingA::objectsA;
		$objects_ref=\@GroupingA::valuesA;
			#create_groupingAo
		create_groupingAv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingB - terrorism, islamophobia and the 'war on terror'
		$active_mod = $modifyers[1];
		$current_grouping = "B";
			#objects not relevant here.
		#$objects_ref=\@GroupingB::objectsB;
		$objects_ref=\@GroupingB::valuesB;
			#create_groupingBo
		create_groupingBv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingC - economy, economic warfare, fiscal policy and employment
		$active_mod = $modifyers[2];
		$current_grouping = "C";
			#objects not relevant here.
		#$objects_ref=\@GroupingC::objectsC;
		$objects_ref=\@GroupingC::valuesC;
			#create_groupingCo
		create_groupingCv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingD - healthcare, the opiate crisis and the pandemic
		$active_mod = $modifyers[3];
		$current_grouping = "D";
			#objects not relevant here.
		#$objects_ref=\@GroupingD::objectsD;
		$objects_ref=\@GroupingD::valuesD;
			#create_groupingDo
		create_groupingDv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingE - racism, immigration, and border control
		$active_mod = $modifyers[4];
		$current_grouping = "E";
			#objects not relevant here.
		#$objects_ref=\@GroupingE::objectsE;
		$objects_ref=\@GroupingE::valuesE;
			#create_groupingEo
		create_groupingEv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingF - the justice system, institutional violence and gun control
		$active_mod = $modifyers[5];
		$current_grouping = "F";
			#objects not relevant here.
		#$objects_ref=\@GroupingF::objectsF;
		$objects_ref=\@GroupingF::valuesF;
			#create_groupingFo
		create_groupingFv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingG - climate change, environmental issues and natural catastrophes
		$active_mod = $modifyers[6];
		$current_grouping = "G";
			#objects not relevant here.
		#$objects_ref=\@GroupingG::objectsG;
		$objects_ref=\@GroupingG::valuesG;
			#create_groupingGo
		create_groupingGv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingH - populists & dictators, domestic terrorism and atrocities
		$active_mod = $modifyers[7];
		$current_grouping = "H";
			#objects not relevant here.
		#$objects_ref=\@GroupingH::objectsH;
		$objects_ref=\@GroupingH::valuesH;
			#create_groupingHo
		create_groupingHv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	#GroupingI - division, election denial and the January 6th insurrection
		$active_mod = $modifyers[7];
		$current_grouping = "I";
			#objects not relevant here.
		#$objects_ref=\@GroupingI::objectsI;
		$objects_ref=\@GroupingI::valuesI;
			#create_groupingIo
		create_groupingIv;
		standard_test;
		$grouping_incidence {$current_grouping} = $standard_incidence_count; 
		
	print $Hf1 "\n";
	print "\n";
	$active_mod = 1;

};

sub grouping_objects {
	
	#Grouping Zero - insult, boast, complaint and irrelevancy signifyers
		create_grouping_zero_o;
	#GroupingA - war, the military and the nuclear threat
		create_groupingAo;
	#GroupingB - terrorism, islamophobia and the 'war on terror'
		create_groupingBo;
	#GroupingC - economy, economic warfare, fiscal policy and employment
		create_groupingCo;
	#GroupingD - healthcare, the opiate crisis and the pandemic
		create_groupingDo;
	#GroupingE - racism, immigration, and border control
		create_groupingEo;
	#GroupingF - the justice system, institutional violence and gun control
		create_groupingFo;
	#GroupingG - climate change, environmental issues and natural catastrophes
		create_groupingGo;
	#GroupingH - populists & dictators, domestic terrorism and atrocities
		create_groupingHo;
	#GroupingI - division, election denial and the January 6th insurrection
		create_groupingIo;
	print "writing objects \n";

};

match_groupings;

#variables for 'check_element' sub
my (
	$query_elements	,
	$query_object	,
	$query_request	,
	$query_result 	,
	$query_count	,
	)	= undef;

my $countIII = undef;

my @finding_total = (0);
my $finding_total_ref = \@finding_total;
my $query 		 = undef;
my $inconclusive = undef;
my $priority_count = undef;
my @active_groupings;  # contains all active groupings.

sub check_element {
	$countI			= 0;
	$query=		scalar(@findings);
	$query_result = 0;
	while ($query > 0) {
		$query_elements = scalar((@{$findings[$countI]}))-1;
		$countIII = scalar((@{$findings[$countI]}))-1;
		#print "query:$query\n\n";

		while ($countIII >0) {
			my $query_finding = $findings[$countI][$countIII] {$query_object};
			if ($query_finding eq $query_request){
				#print "query triggered: $query_finding $query_elements\n";
				$query_result = 1;
				#print "$query_result\n";
				$query_count++;
			};
			$countIII--;
		};
		$countI++;	
		$query--;
	};
	$countI			= 0;
};

my (
	$query_total	,
	$query_total_sub,
	$query_adj		,
	$query_adj_sub	,
	$query_name		,
	$query_name_sub	,
	$query_concrete		,
	$query_concrete_sub	,
	$query_abstract		,
	$query_abstract_sub	,
	$query_high_relevance		,
	$query_high_relevance_sub	,
	$query_normal_relevance		,
	$query_normal_relevance_sub	,
		$query_finding_wieght	,
		$query_timesensitivity	,
		$query_timesensitivity_sub	,
	$unique_source	,
	$chosen_unique_source	,
	$standard_source	,
	$chosen_standard_source		,
	$escalated_source 	,
	$chosen_escalated_source	,
		$incidence_counter	,
		$modval_part	,
		$context	,
		$direct_match	,
	) = undef;
$chosen_unique_source ="null";

sub add_values {
	$countI			= 1;
	$query=		(scalar(@findings)-1);
	my $addone =0;
	while ($query >= 1) {
		
		my %current_findings = ();
		my $current_findings_ref = \%current_findings;
		$query_elements = scalar((@{$findings[$countI]}))-1;
		$countIII = scalar((@{$findings[$countI]}))-1;
		if ($countIII > 0){
				if ($addone >= $countIII) {
					push @finding_total, $addone;
					$addone++;
				};
				my $valueadder	= 1;
				$query_adj 		= 0;
				$query_total	= 0;
				$query_name		= 0;
				$query_concrete	= 0;
				$query_abstract	= 0;
				$query_high_relevance	= 0;
				$query_normal_relevance	= 0;
				$query_finding_wieght	= 0;
				$incidence_counter		= 0;
				$modval_part			= 0;
				$query_timesensitivity	= 0;
				$context	= 0;
				$direct_match 	= 0;
				while ($valueadder <= $countIII) {
					
					$query_total_sub= 0;
					$query_adj_sub 	= 0;
					$query_name_sub = 0;
					$query_concrete_sub	= 0;
					$query_abstract_sub	= 0;
					$query_high_relevance_sub	= 0;
					$query_normal_relevance_sub	= 0;
					$query_timesensitivity_sub	= 0;
					$incidence_counter++;
					
					#excluding context
					
					if ($findings[$countI][$valueadder] {"relevance"} == 2){
						$context = 1;
						}
					else {
						$direct_match = 1;
					};
					
					$query_total_sub = $findings[$countI][$valueadder] {"sig"} + $findings[$countI][$valueadder] {"func"} + $findings[$countI][$valueadder] {"stat"};
		
					if ($findings[$countI][$valueadder] {"timesensitive"} == 1) {
						if ($query_total_sub >= 4 ) {
							$query_timesensitivity_sub++
						};
					};
					
					if ($findings[$countI][$valueadder] {"wordtype"} eq "adjective") {$query_adj_sub++};
					if ($findings[$countI][$valueadder] {"wordtype"} eq "name") {$query_name_sub++};
					if ($findings[$countI][$valueadder] {"wordtype"} eq "concrete noun" or $findings[$countI][$valueadder] {"wordtype"} eq "plural concrete noun") {$query_concrete_sub++};
					if ($findings[$countI][$valueadder] {"wordtype"} eq "abstract noun" or $findings[$countI][$valueadder] {"wordtype"} eq "plural abstract noun") {$query_abstract_sub++};
					if ($findings[$countI][$valueadder] {"wordtype"} eq "name") {$query_name_sub++};
					
					my @temp_queryvals=( $findings[$countI][$valueadder] {"sig"} , $findings[$countI][$valueadder] {"func"} , $findings[$countI][$valueadder] {"stat"} );
					foreach my $testvalues (@temp_queryvals) {
						if ($testvalues > 2) {$query_high_relevance_sub++};
						if ($testvalues > 1) {$query_normal_relevance_sub++};
					};
					
					$standard_source	= $findings[$countI][$valueadder] {"standard_source"};
					$escalated_source 	= $findings[$countI][$valueadder] {"escalated_source"};
					$unique_source		= $findings[$countI][$valueadder] {"unique_source"};
					if($unique_source		eq "undef"){$unique_source="null"};
					#print "test: $escalated_source  \n";
					unless ($standard_source eq "undef"){
						# print "$standard_source\n";
						if ($query_finding_wieght == 0 or $query_finding_wieght < $query_total_sub) {
							$chosen_standard_source		= $standard_source;
							if ($escalated_source eq "null"){ 
								#print "$escalated_source eq null\n";
								$chosen_escalated_source	= undef;	
							}
							else {
								#print "$escalated_source ne null\n";
								$chosen_escalated_source	= $escalated_source;	
							
							};
							if($unique_source ne "null") {
								#print "unique source present\n";
								$chosen_unique_source = $unique_source;
							};	
						}
						elsif ($query_finding_wieght == $query_total_sub) {
							my $random_choice = int(rand(2));
							if ($random_choice == 0) {
								$chosen_standard_source		= $standard_source;
								$chosen_escalated_source	= $escalated_source;
					
							}
							else {};
							if($unique_source ne "null") {
								#print "unique source present\n";
								$chosen_unique_source = $unique_source;
							};	
						};
						#if($unique_source ne "null") {
							##print "unique source present\n";
							#$chosen_unique_source = $unique_source;
						#};
					};
					
					$query_total	=	$query_total+$query_total_sub;
					$query_adj		=	$query_adj_sub+$query_adj;
					$query_name		=	$query_name_sub+$query_name;
					$query_concrete	=	$query_concrete + $query_concrete_sub;
					$query_abstract	=	$query_abstract + $query_abstract_sub;
					$query_high_relevance	= $query_high_relevance + $query_high_relevance_sub;
					$query_normal_relevance	= $query_normal_relevance + $query_normal_relevance_sub;
					$query_timesensitivity	= $query_timesensitivity + $query_timesensitivity_sub;
					
					$active_mod  = $modifyers[$countI];
					print "query:$countI, mod: $active_mod\n";
					
					$modval_part = (($query_total/$incidence_counter)/3)*$active_mod;
					
					$valueadder++;
					$current_findings {"incidence"} 		=	$incidence_counter;
					$current_findings {"modval"}			=	$modval_part;
					$current_findings {"total"}				=	$query_total;
					$current_findings {"adjective"}			=	$query_adj;
					$current_findings {"name"} 				=	$query_name;
					$current_findings {"concrete"} 			=	$query_concrete;
					$current_findings {"abstract"}			=	$query_abstract;
					$current_findings {"high_relevance"} 	=	$query_high_relevance;
					$current_findings {"normal_relevance"} 	=	$query_normal_relevance;
					$current_findings {"timesensitivity"} 	=	$query_timesensitivity;
					$current_findings {"standard_source"} 	=	$chosen_standard_source;
					$current_findings {"escalated_source"} 	=	$chosen_escalated_source;
					$current_findings {"unique_source"} 	=	$chosen_unique_source;
					$current_findings {"context"} 			=	$context;
					$current_findings {"direct_match"} 		=	$direct_match;
					$current_findings {"mod"} 				=	$active_mod;
					#print "$chosen_unique_source;\n"
				};
				
				push(@{$findings[$countI]}, "summarised values");
				push(@{$findings[$countI]}, $current_findings_ref);
				
			};	
		$countI++;
		$query--;
		#print "$countIII - - $query_total\n";
	};
	$countI			= 0;
};



my (
	$grouping_count	,
		$discard_active	,
		$discard_filter_active	,
		$discard_result	,
	$results,	
	$divisor_incidence	,
	$incidendce_total	,
	$sum_total	,
	$minor_divisor_incidence	,
	$minor_incidendce_total	,
	$minor_sum_total	,
	) = undef;


my $countII 			= 0;
$sum_total				= 0;
$discard_active 		= 0;
$discard_filter_active 	= 0;
$results 				= 0;
$divisor_incidence		= 0;
$incidendce_total		= 0;
$minor_divisor_incidence = 0;
$minor_incidendce_total = 0;
	
sub printdebug {
	print "\n\n###discard-sort###\n";
	print "query_elements: $query_elements\n";
	print "irrelevance count: $irrelevance_count\n";
	print "zero results: $results\n";
	print "query result: $query_result\n";
	print "query count: $query_count\n";
	print "grouping_count: $grouping_count\n";
	print "irrel_count: $irrelevance_count\n";
	print "###-###\n\n";
};

#printdebug;
#reading em values -> active_state/Analysis_Data/Twitter/evaluation.conf"
$Config	= Config::Tiny->read("$home/$em_path");

	# reading em values
		my $anger		= $Config->{emotion}->{anger};
		my $anticipation= $Config->{emotion}->{anticipation};
		my $disgust		= $Config->{emotion}->{disgust};
		my $fear		= $Config->{emotion}->{fear};
		my $joy			= $Config->{emotion}->{joy};
		my $sadness		= $Config->{emotion}->{sadness};
		my $surprise	= $Config->{emotion}->{surprise};
		my $trust		= $Config->{emotion}->{trust};
		
	# reading disposition values
		my $mean		= $Config->{neutrality}->{disposition_mean};
		my $sum			= $Config->{neutrality}->{disposition_sum};
		my $sentence_total = $Config->{neutrality}->{sentence_total};

	# emotional eval sums
		my $positive_em = ($joy + $trust + $surprise + $anticipation);
		my $negative_em = ($anger + $disgust + $sadness + $fear);
		my $em_total 	= $negative_em + $positive_em;


sub standard_analysis {
	#outputs essential values such as the number of significant elements in the respective groupings

	#analysis on results:
	$countI			= 0;
	$grouping_count = 0;
	$discard_result = scalar(@{$findings[0]});
		
	foreach my $grouping (@findings) {
		$results = 0;
		$results = scalar((@{$findings[$countI]}))-1;
		if ($results > 0) {
			unless ($countI ==0) {
				push @active_groupings, $countI;
				};
			$grouping_count++
			};
		$countI++;	
	};
	
	if ($discard_result > 1) {
		$grouping_count--;
		print "reducing grouping_count by one \n";
	};

	#test for presence of links:
	$query_object = "object";
	$query_request = "irrelevant";
	$query_count = 0;
	check_element;
	my $irrelevance_count = $query_count;
	
	$query_object = "sig";
	$query_request = "link";
	$query_count = 0;
	check_element;	
	
	#test for discard matches 
	if ($query_result==1) {
		if ($grouping_count == 0) {
			print "\ndiscard 1 - discard is active!\n";
			print  $Hf1 "\ndiscard 1 - discard is active!\n";
			$discard_active = 1;
			printdebug;
		}
		elsif($grouping_count > 0 && $query_count < $irrelevance_count) {
			print "\ndiscard 1, link + possibly irrelevant match found";
			print  $Hf1 "\ndiscard 1, link + possibly irrelevant match found";
			$discard_filter_active = 1;
			printdebug;
		}
		else {
			print "\ndiscard 0, link + relevant match found";
			print  $Hf1 "\ndiscard 0, link + relevant match found";
			$discard_active = 0;
			printdebug;
		};
	}
	elsif ($query_count > $irrelevance_count) {
			print "\ndiscard 1, possibly irrelevant match found ";
			print  $Hf1 "\ndiscard 1, possibly irrelevant match found";
			$discard_filter_active = 1;
			printdebug;
	}
	else {
			print "\ndiscard 0";
			print  $Hf1 "\ndiscard 0";
			$discard_active = 0;
			printdebug;
	};
	
	add_values;	
	
};

my @filter_elements;
my %test_groupings;
my ($context_on	,
	$context_off	,
	$context_discard	,
	)= undef;

$context_on  = 0;
$context_off = 0;
$context_discard = 0;

sub assesment {
	if ($discard_active == 1 && $discard_filter_active == 0) {
		
	print "Tweet has been discarded!\n";
	print $Hf1 "Tweet has been discarded!\n";
	
	#what export scenario takes place here? Setting relevant variables must occur.
	}
	else {

		foreach my $filter_grouping (@active_groupings) {
			
			my $temp_grouping_scalar	= (scalar((@{$findings[$filter_grouping]})))-1;
			
			my $finding_context			= $findings[$filter_grouping][$temp_grouping_scalar] {"context"};
			my $finding_direct_match	= $findings[$filter_grouping][$temp_grouping_scalar] {"direct_match"};
			
			if ( $finding_context == 1 && $finding_direct_match == 0 ){
				$context_on = 1;
				}
			else {
				$context_off = 1;
			};
		};
		
		if ( $context_on == 1 && $context_off == 0 ){
			
			my $negative_content = $insult_count + $boast_count + $complaint_count;
			if ($discard_filter_active == 0 && $em_total >= 1) {
				if($negative_content>0) {
					$context_discard = 0;
					print "\nviable context -> match validated!\n";
					print $Hf1 "\nviable context -> match validated!\n";
					}
				else {
					print "\ncontext not valid. match discarded!\n";
					print $Hf1 "\ncontext not valid -> match discarded!\n";
					$context_discard = 1;
					$grouping_count = 0;
					};
				}
			else{
				print "\ncontext not valid -> match discarded!\n";
				print $Hf1 "\ncontext not valid -> match discarded!\n";
				$context_discard = 1;
				$grouping_count = 0;
			};
		};
		unless ($grouping_count<=0){
			#print "\nrelevant groupings:\n";
			#print $Hf1 "\nrelevant groupings:\n";
		};
		print $Hf1 "\n\n";
		
		#testing for correlated groupings
		
		my $correlation_AB = undef;
		my $correlation_EFHI = undef;
		my $correlation_EFHI_counter = undef;
		
		$correlation_AB = 0;
		$correlation_EFHI = 0;
		$correlation_EFHI_counter = 0;
		
		if (scalar((@{$findings[1]})) > 1 && scalar((@{$findings[2]})) > 1) {
			$correlation_AB = 1;
		};
		if (scalar((@{$findings[5]})) > 1) {
			$correlation_EFHI_counter ++;
		};
		if (scalar((@{$findings[6]})) > 1) {
			$correlation_EFHI_counter ++;
		};
		if (scalar((@{$findings[8]})) > 1) {
			$correlation_EFHI_counter ++;
		};
		if (scalar((@{$findings[9]})) > 1) {
			$correlation_EFHI_counter ++;
		};
		if ($correlation_EFHI_counter > 1) {
			$correlation_EFHI = 1;
		};
		
		print "grouping correlation: AB = $correlation_AB, EFHI = $correlation_EFHI \n";
		
		foreach my $currnent_grouping (@active_groupings) {
			
			unless ($context_discard ==1) {		
				my $loop_result = undef;
				my $loop_sum 	= undef;
				my $simple_loop_result =undef;
				$loop_sum		= 0;
				$loop_result	= 0;
				unless ($currnent_grouping == 0) {
					#
					print  " ", $g_l [($currnent_grouping -1)], ": ";
					print $Hf1 " ", $g_l [($currnent_grouping -1)], ": ";
					#
					my $temp_grouping_scalar	= (scalar((@{$findings[$currnent_grouping]})))-1;
					
		#	#	#	#filter high_priority:
					my $normal_relevance_temp	= $findings[$currnent_grouping][$temp_grouping_scalar] {"normal_relevance"};
					my $high_relevance_temp		= $findings[$currnent_grouping][$temp_grouping_scalar] {"high_relevance"};
					if ($normal_relevance_temp > 0 or $high_relevance_temp > 0){
						if ($g_l_val [($currnent_grouping -1)] == 1)	{
							print "high_priority, ";
							print $Hf1 "high_priority, ";
							$loop_sum++;
						};
					};
					
		#	#	#	#filter climate_priority (this one tends to be undervalued):
					if ($normal_relevance_temp > 0 or $high_relevance_temp > 0){
						if ($g_c_val [($currnent_grouping -1)] == 1)	{
							print "climate_priority, ";
							print $Hf1 "climate_priority, ";
							$loop_sum++;
						};
					};
					
		#	#	#	#filter correlation (GroupingE is nerfed):
					my $filter_grouping	= $findings[$currnent_grouping][0];
					
					#AB filter
					if ($correlation_AB == 1) {
						if ($filter_grouping eq "GroupingA" or $filter_grouping eq "GroupingB") {
							print "linked groupings (A,B), ";
							print $Hf1 "linked groupings (A+B), ";
							$loop_sum++;
							$loop_sum++;
							};
						};
					#EFHI filter
					#if ($correlation_EFHI == 1) {
						#if ($filter_grouping eq "GroupingF" or $filter_grouping eq "GroupingH") {
							#print "linked groupings (E,F,H,I), ";
							#print $Hf1 "linked groupings (E,F,H,I), ";
							#$loop_sum++;
							#};
						#};
					
					my $temp_mention = $mentioned_groupings_count {$g_l [($currnent_grouping -1)]};
					
					#context links
					if ($temp_mention > 0 ){	
						my $mention_count_temp = $mentioned_groupings_count {$g_l [($currnent_grouping -1)]};		
						#$loop_sum = ($loop_sum + $mention_count_temp);
						#unless ($filter_grouping eq "GroupingE") {
							print "correlated (", $mentioned_groupings_count {$g_l [($currnent_grouping -1)]}, "), ";
							print $Hf1 "correlated (", $mentioned_groupings_count {$g_l [($currnent_grouping -1)]}, "), ";
							$loop_sum++;
						#};
					};
					
		#	#	#	#word filter
					my $adjective_temp	= $findings[$currnent_grouping][$temp_grouping_scalar] {"adjective"};
					my $concrete_temp	= $findings[$currnent_grouping][$temp_grouping_scalar] {"concrete"};
					my $abstract_temp	= $findings[$currnent_grouping][$temp_grouping_scalar] {"abstract"};
					if ($adjective_temp > 0 or $concrete_temp >= 2 or $abstract_temp >= 2){
						my @relevant_words_temp;
						if ($adjective_temp > 0){
							push (@relevant_words_temp, "adjective ");
							$loop_sum++;
						};
						if ($concrete_temp >= 2){
							push (@relevant_words_temp, "concrete noun ");	
							$loop_sum++;
						};
						if ($abstract_temp >= 2){
							push (@relevant_words_temp, "abstract noun ");
							$loop_sum++;
						};
						print "relevant wordtype ( @relevant_words_temp", "), ";
						print $Hf1 "relevant wordtype ( @relevant_words_temp", "), ";
					};
					
		#	#	#	#source filter
					my $escalated_temp	= $findings[$currnent_grouping][$temp_grouping_scalar] {"escalated_source"};
					my $unique_temp		= $findings[$currnent_grouping][$temp_grouping_scalar] {"unique_source"};
	
					if (defined($escalated_temp) or $unique_temp ne 'null'){
						my @relevant_words_temp;
						#if (defined($escalated_temp)) {push (@relevant_words_temp, "$escalated_temp -> ++ ");
						if (defined($escalated_temp)) {push (@relevant_words_temp, " ++ ");
							$loop_sum++;
						};
						#if ($unique_temp ne 'null')  {push (@relevant_words_temp, "$unique_temp -> +++");	
						if ($unique_temp ne 'null')  {
							push (@relevant_words_temp, " +++ ");	
							$loop_sum++;
						};
						print "relevant source: ( @relevant_words_temp", "), ";
						print $Hf1 "relevant source: ( @relevant_words_temp", "), ";
					};
					
		#	#	#	#time filter
					my $time_temp		= $findings[$currnent_grouping][$temp_grouping_scalar] {"timesensitivity"};
					if ($time_temp > 0){
						print "timesensitive, ";	$loop_sum++;
					};	
					
		#	#	#	#finalizing results
					my $modifyer		= $findings[$currnent_grouping][$temp_grouping_scalar] {"mod"};
					my $modval_temp		= $findings[$currnent_grouping][$temp_grouping_scalar] {"modval"};
					my $incidence_temp	= $findings[$currnent_grouping][$temp_grouping_scalar] {"incidence"}; 
					print "modval: $modval_temp, ";
					print  "\n";
					print $Hf1 "modval: $modval_temp, ";
					print $Hf1 "\n";
					if ($loop_sum == 0) {
						$loop_result = 1 + $modval_temp /10;
						#$loop_result = 1;
						$simple_loop_result = 0;
						}
					else{
						$loop_result = ($loop_sum*$modval_temp)/$incidence_temp;						
						#print "it: $loop_result = ($loop_sum*$modval_temp)/$incidence_temp\n";
						$simple_loop_result =$incidence_temp*$modifyer;
						#print "st: $simple_loop_result =$incidence_temp*$modifyer\n";
						#$loop_result = ($loop_sum*$modval_temp);
					};
					$test_groupings {$loop_result} = $currnent_grouping;
				};
		#	#	#finishing
				print "loop done - result: $loop_result ($loop_sum);\n\n";
				print $Hf1 "loop done - result: $loop_result ($loop_sum);\n\n";
				
				if ($loop_result > 0) {
					if ($loop_result >= 1) {
						$divisor_incidence++;
						
						$sum_total = $sum_total + $simple_loop_result;
						
						$incidendce_total = $incidendce_total+$loop_result;
					}
					else {
						$minor_divisor_incidence++;
						
						$sum_total = $sum_total + $simple_loop_result;
						
						$minor_incidendce_total = $minor_incidendce_total+$loop_result;
						print "minor incidence noted \n";
					};
				};
				
				#may be mistake! see if tests show different vaules
				#if ($loop_result > 0) {
						#$divisor_incidence++;
						#$sum_total = $sum_total + $simple_loop_result;
						#$incidendce_total = $incidendce_total+$loop_result;
						##print "## test - it: $incidendce_total st: $sum_total\n\n";
				#};
			};
		};
	};	
};



#running subroutines
standard_analysis;print "## $grouping_count\n";
assesment;
my ($highest_loop_result	,
	$required	,
	$highest_grouping_name	,
	$highest_grouping_scalar	,
	$dominant_value	,
	) = undef;
$dominant_value	= 0;
							#(a,b,c,d,e,f,g,h,i);
my @dominant_grouping_vals = (0,1,2,3,4,5,6,7,8); #high priority groupings

unless ($grouping_count<=0) {
	print "required!\n";
	$highest_loop_result = max keys %test_groupings;
	$required = $test_groupings{$highest_loop_result};
	$highest_grouping_name = $g_l [($required -1)];
	
	$dominant_value	= $dominant_grouping_vals [($required -1)];
	
	print "Grouping $highest_grouping_name predominant! [$dominant_value]\n";
	print $Hf1 "Grouping $highest_grouping_name predominant! [$dominant_value]\n ";
	$highest_grouping_scalar	= (scalar((@{$findings[$required]})))-1;
};
		
my @emotions = ($anger, $anticipation, $disgust, $fear, $joy, $sadness, $surprise, $trust);

my ($emotion_incidence	,
	$content_modifyer	,
	$mean_intent	,
	$ultra_mean	,
	) = undef;
$emotion_incidence = 0;
foreach my $emotion_test (@emotions) {
	unless ($emotion_test == 0) {
		$emotion_incidence++;
		};
	};

if ($divisor_incidence >= 1) {
	if ($insult_count > 0) {
		$divisor_incidence++;
		$incidendce_total= $incidendce_total + ($insult_count*$zero_modifyers[0]);
		$sum_total = $sum_total + ($insult_count*$zero_modifyers[0]);
		};
	if ($boast_count > 0) {
		$divisor_incidence++;
		$incidendce_total= $incidendce_total + ($boast_count*$zero_modifyers[1]);
		$sum_total = $sum_total + ($boast_count*$zero_modifyers[1]);
		};
	if ($complaint_count > 0) {
		$divisor_incidence++;
		$incidendce_total= $incidendce_total + ($complaint_count*$zero_modifyers[2]);
		$sum_total = $sum_total + ($complaint_count*$zero_modifyers[2]);
		};
	$content_modifyer = $incidendce_total/$divisor_incidence-1;
	if ($content_modifyer < 0) {
		$content_modifyer = 0;
		print "negative content modifyer. resett to 0.\n";
		};
	print"p inc: $content_modifyer = $incidendce_total/$divisor_incidence -1\n";
	#$content_modifyer = $incidendce_total;
	}
elsif(($insult_count + $boast_count +$complaint_count)==0) {
	$content_modifyer = 1.01;
	}
else {
	if ($insult_count > 0) {
		$minor_divisor_incidence++;
		$minor_incidendce_total= $minor_incidendce_total + ($insult_count*$zero_modifyers[0]);
		$sum_total = $sum_total + ($insult_count*$zero_modifyers[0]);
		$active_mod = $zero_modifyers[0];
		};
	if ($boast_count > 0) {
		$minor_divisor_incidence++;
		$minor_incidendce_total= $minor_incidendce_total + ($boast_count*$zero_modifyers[1]);
		$sum_total = $sum_total + ($boast_count*$zero_modifyers[1]);
		$active_mod = $zero_modifyers[1];
		};
	if ($complaint_count > 0) {
		$minor_divisor_incidence++;
		$minor_incidendce_total= $minor_incidendce_total + ($complaint_count*$zero_modifyers[2]);
		$sum_total = $sum_total + ($complaint_count*$zero_modifyers[2]);
		$active_mod = $zero_modifyers[2];
		};
	$content_modifyer = $minor_incidendce_total/$minor_divisor_incidence-1;
	if ($content_modifyer < 0) {
		$content_modifyer = 0;
		print "negative content modifyer. resett to 0.\n";
		};
	print"s inc: $content_modifyer = $minor_incidendce_total/$minor_divisor_incidence-1\n";
	};

my @em_totals = ($positive_em, $negative_em);
my $prime_em_sett = max @em_totals;
my $sec_em_sett = min @em_totals;

unless ($grouping_count<=0) {
$active_mod	= $findings[$required][$highest_grouping_scalar] {"mod"};
#print "active_mod = $active_mod\n"
};

if ($emotion_incidence == 0) {
	print "\nmodifyer: $content_modifyer \n";
	print $Hf1 "\nmodifyer: $content_modifyer \n";
	$ultra_mean = ($active_mod*$content_modifyer);
	}
else {
	print "\nmodifyer: $content_modifyer \n";
	print $Hf1 "\nmodifyer: $content_modifyer \n";
	$ultra_mean = ((($prime_em_sett*$active_mod) + $sec_em_sett) * $content_modifyer)/17
	};

my ($standard	,
	$escalated	,
	$unique	,
	$active_source	,
	)= undef;
my $image_test = $em_total *  $ultra_mean;
my $image_promt = undef;
$image_promt = 0;
unless ($grouping_count<=0) {
	$standard	= $findings[$required][$highest_grouping_scalar] {"standard_source"};
	$escalated	= $findings[$required][$highest_grouping_scalar] {"escalated_source"};
	$unique		= $findings[$required][$highest_grouping_scalar] {"unique_source"};
	$active_source = undef;
	
	print "Active Image source:\n";
	
	if ($ultra_mean > 3) {
		
		if ($unique ne 'null')  {
			print"unique source:$unique\n";
			$active_source = $unique;
			}
		elsif (defined($escalated)) {
			print"escalated source:$escalated\n";
			$active_source=$escalated;
			}
		else {
			print"standard source:$standard\n";
			$active_source=$standard;
			};
			
		}
	
	elsif ($ultra_mean > 2) {
		
		if ($unique ne 'null')  {
			print"unique source:$unique\n";
			$active_source = $unique;
		}
		else {
		print"standard source:$standard\n";
		$active_source=$standard;
		};
		
	}
	
	else {
		
		print"standard source:$standard\n";
		$active_source=$standard;
		
	};
	
	print "active source: $active_source\n";
	print $Hf1 "active source: $active_source\n";
	
	#setting image prompt
	$image_promt = 1;
	if ($image_test <= 0.5) {
		print "\nfinding too miniscule, image promt inhibited.\n";
		print $Hf1 "\nfinding too miniscule, image promt inhibited.\n";
		$image_promt = 0;
	};

};

#debug - show generated values
print "insult: $insult_count\n";
print "boast: $boast_count\n";
print "complaint: $complaint_count\n";
print "em incidence and total: $emotion_incidence, $em_total\n";
print "incidence total:$incidendce_total \n";
print "divisor incidence:$divisor_incidence \n";
#print "content modifyer:$content_modifyer, final modifyer: $ultra_mean\n";
print "discard:$discard_active, strict discard filter: $discard_filter_active \n";
print "dread accumulation type: $dominant_value \n";
print "groupingcount: $grouping_count\n";
print "Image Prompt: $image_promt\n";
print $Hf1 "\n\n::DEBUG VALUES::\n";
print $Hf1 "	incidence total:$incidendce_total \n";
print $Hf1 "	divisor incidence:$divisor_incidence \n";
#print $Hf1 "	content modifyer:$content_modifyer, final modifyer: $ultra_mean\n";
print $Hf1 "	discard:$discard_active, strict discard filter: $discard_filter_active \n";
print $Hf1 "	dread accumulation type: $dominant_value \n";

#defining output file for findings dump:
my $finding_text = "$text_data/finding_text_I.txt";
open( $Hf2, '>', "$home/$finding_text")
or die "Could not open file ' finding_text_I.txt'";

#grouping_objects;

#debug - show array contents
	#print"\n";
	print Dumper @findings;
	#print"active:\n";
	#print Dumper @active_groupings;
	#print"mentioned:\n";
	#print Dumper @mentioned_groupings;
	#print Dumper %mentioned_groupings_count;
	#print "test\n";
	#print Dumper %grouping_positions;
	#print "filter\n";
	#print Dumper @filter_elements;
	#print Dumper %test_groupings;
	#print Dumper @g_l;
	#print Dumper @g_l_val;
	#print "\n\n output incidence:\n";
	#print Dumper %grouping_incidence;
	my $findings_text = Dumper @findings;
	print $Hf2 $findings_text;
	close $Hf2;
	
	#open(my $fh11, '<:encoding(UTF-8)', $filename11)
	#or die "Could not open file '$filename11' $!";
	#$finding_lines++ while (<$fh11>);
	
	my $finding_lines = undef;
	
	open(my  $Hf3, '<:encoding(UTF-8)', "$home/$finding_text")
	or die "Could not open file ' finding_text.txt'";
	
	my $finding_text_final = "$text_data/finding_text.txt";
	open(my $Hf4, '>', "$home/$finding_text_final")
	or die "Could not open file ' finding_text.txt'";
	
	while (my $finding_line = <$Hf3>) {
		if ($finding_line =~'          ') {
			$finding_line =~s/          /········· /;
			#$finding_line =~s/          / ·· /;
			print $Hf4 $finding_line;
			}
		elsif ($finding_line =~'        ') {
			$finding_line =~ s/        /······· /;
			#$finding_line =~ s/        / · /;
			print $Hf4 $finding_line;
		}
		else {print $Hf4 $finding_line;};
	};
	print $Hf4 "];\n";
	print Dumper @emotions;
#
	#my $dominant_dread0	= $Config->{content}->{dominant_dread};	
sub export_values {

#config file
	$Config	= Config::Tiny->read("$home/$em_path");
	
#names
	unless ($grouping_count<=0) {
		$Config->{class}->{dread}	= $highest_grouping_name;	
	};
	
#values		
	$Config->{content}->{discard}	= $discard_active;	
	$Config->{content}->{insult}	= $insult_count;	
	$Config->{content}->{boast}		= $boast_count;		
	$Config->{content}->{complaint}	= $complaint_count;	
	$Config->{content}->{dread}		= $grouping_count;
	$Config->{content}->{dominant_dread} = $dominant_value;
	
	$Config->{content}->{image_promt} = $image_promt;
	
#modifyers
	$Config->{neutrality}->{inversion_neg1}		= $ultra_mean;
	$Config->{neutrality}->{inversion_neg2}		= $ultra_mean;
	$Config->{neutrality}->{inversion_pos1}		= $ultra_mean;
	$Config->{neutrality}->{inversion_pos2}		= $ultra_mean;
	$Config->{neutrality}->{ultra_mean}		= $ultra_mean;
	
#write to file
	$Config->write("$home/$em_path");
			
};

export_values;

sub export_source_path {
#config file
	$Config	= Config::Tiny->read("$home/$status_path");
#value
unless ($grouping_count<=0) {
	$Config->{tweet}->{source} = "$source_path/$active_source";
}
#write to file
	$Config->write("$home/$status_path");

};
export_source_path;

#END
close $Hf1;
exit;
