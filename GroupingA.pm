package GroupingA;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw( create_groupingAv create_groupingAo );
our $catval = undef;
use Data::Dumper qw(Dumper);
##############
# Grouping A #
##############	

	our @Aword =	(
		"null",	#	#	#	#	#	#	#[0]
		"name", #	#	#	#	#	#	#[1]
		"adjective",	# 	#	#	#	#[2]
		"abstract noun",#	#	#	#	#[3]
		"plural abstract noun",	#	#	#[4]
		"concrete noun",#	#	#	#	#[5]
		"plural concrete noun","slogan"	#[6]
	);
	
	our @Asig =	(
		"null",	#[0]
		"country",	#[1]
		"nationality",	#[2]
		"territory",	#[3]
		"city",	#[4]
		"person",	#	#	#	#	#	#[5]
		"nationals",#	#	#	#	#	#[6]
		"organization",	#	#	#	#	#[7]
		"minority", #	#	#	#	#	#[8]
		"military weapon", 	#	#	#	#[9]
		"banned weapon",#	#	#	#	#[10]
		"nuclear weapon",	#	#	#	#[11]
		"act of violence",	#	#	#	#[12]
		"nuclear material",	#	#	#	#[13]
		"capacity for violence",#	#	#[14]
	);
	our @Asigval=(
		0,	#	#	#	#[0]
		1,	#	#	#	#[1]
		1,	#	#	#	#[2]
		1,	#	#	#	#[3]
		1,	#	#	#	#[4]
		1,	#	#	#	#[5]
		1,	#	#	#	#[6]
		1,	#	#	#	#[7]
		2, 	#	#	#	#[8]
		2, 	#	#	#	#[9]	
		3,	#	#	#	#[10]
		3,	#	#	#	#[11]
		2,	#	#	#	#[12]	
		3,	#	#	#	#[13]
		3	#	#	#	#[14]
	);
	
	our @Afunc =	(
		"null",	#	#	#	#	#	#	#[0]
		"war zone",	#	#	#	#	#	#[1]
		"capital",	#	#	#	#	#	#[2]
		"belligerent",	#	#	#	#	#[3]
		"province",	#	#	#	#	#	#[4]
		"dictator",	#	#	#	#	#	#[5]
		"leader",	#	#	#	#	#	#[6]
		"border zone",	#	#	#	#	#[7]
		"atomic power",	#	#	#	#	#[8]
		"aspiring atomic power",#	#	#[9]
		"general",	#	#	#	#	#	#[10]
		"conventional weapon",	#	#	#[11]
		"weapon of mass destruction",#	#[12]
		"nuclear armament",	#	#	#	#[13]
		"president"	#	#	#	#	#	#[14]
	);
	our @Afuncval= (
		0,	#	#	#	#[0]
		2,	#	#	#	#[1]	
		1, 	#	#	#	#[2]
		2,	#	#	#	#[3]
		1,	#	#	#	#[4]
		2, 	#	#	#	#[5]
		2, 	#	#	#	#[6]
		2,	#	#	#	#[7]
		2, 	#	#	#	#[8]
		3, 	#	#	#	#[9]	
		3,	#	#	#	#[10]
		2,	#	#	#	#[11]
		3,	#	#	#	#[12]	
		3,	#	#	#	#[13]
		0	#	#	#	#[14]
	);
	
	our @Astat =	(
		"null", #	#	#	#	#	#	#[0]		
		"unstable",	#	#	#	#	#	#[1]
		"threatening",	#	#	#	#	#[2]
		"threatened",	#	#	#	#	#[3]
		"occupied",	#	#	#	#	#	#[4]
		"governing",#	#	#	#	#	#[5]
		"deceased",	#	#	#	#	#	#[6]
		"allied", 	#	#	#	#	#	#[7]
		"contested",#	#	#	#	#	#[8]
		"deadly",	#	#	#	#	#	#[9]	
		"horrifying",	#	#	#	#	#[10]
		"defeated"	#	#	#	#	#	#[11]
	);
	our @Astatval=(
		0, 	#	#	#	#[0]	
		2,	#	#	#	#[1]	
		2,	#	#	#	#[2]
		2,	#	#	#	#[3]
		1,	#	#	#	#[4]
		1,	#	#	#	#[5]
		0,	#	#	#	#[6]
		1, 	#	#	#	#[7]
		2,	#	#	#	#[8]
		2,	#	#	#	#[9]	
		3,	#	#	#	#[10]
		0	#	#	#	#[11]
	);
	
	our @Atime =	(
		"null",
	 	"null" 
	 );	


# predefining necessary variables
	our $Asig_ref 	= undef;
	our $Afunc_ref	= undef;
	our $Astat_ref	= undef;
	our @iraq		= undef;
	our @afghanistan= undef;
	our @syria		= undef;
	our @ukraine		= undef;
	our @palestine	= undef;
	our @north_korea= undef;
	our @china		= undef;
	our @russia		= undef;
	our @iran		= undef;
	our @weapons	= undef;
	our @nuclear_threat	= undef;
	our @conflict_rhetoric	= undef;	
	our @Acontext	= undef;	

	our $Arand_four = int(rand(4));
	our $Arand_three = int(rand(3));
	our $Arand_two 	= int(rand(2));
	our $one		= 1;
	
	#our @Apool_1 = ("Wolverine1", "Terminator1", "Terminator2");	#abstract / diffuse / nuclear -> explicit in last source
	#our @Apool_2 = ("Watchmen1", "Jarhead1", "Jarhead2");			#conventional / brutal
	#our @Apool_3 = ("Jarhead3", "Watchmen2", "Watchmen3");			#threat / military control
	
	
	#looming, wtc, inconvinient, host
	
	#/the looming tower -9/11 perpetrators using a flight simlator, WTC - shadow of a 747 moving across a building, an inconvinient truth  -rising sealevel dramatically illustrated above ground zero, the host -agent yellow,
	
#defining scene pools for this grouping		
 #american wars - 
  #+
	#/the host -agent yellow, jarhead -platoon doing chemical attack drill in the desert, jarhead -soldier spectating distant oilwell plume.
	our @Apool_1 = ("The_Host5", "Jarhead1", "Jarhead3"); 
  #++
	#/jarhead -swofford at scene of a war crime, watchmen, -dr manhattan waging war, the wolverine - distant view of b21 aproaching nagasaki bay, jarhead -soldiers under hellish oilwell plumes,
	our @Apool_2 = ("Jarhead2", "Watchmen1", "Wolverine1", "Jarhead4");	
  #unique -
		#/the looming tower -9/11 perpetrators using a flight simlator, the host -agent yellow, an inconvinient truth -rising sealevel dramatically illustrated above ground zero
	our @Apool_unique_1 = ("Looming1", "The_Host5", "Inconvinient1");
	
	our @Apool_unique_2 = ();
  
 #ukraine - 
  #+
	#/under the skin -threshold of the forrest, the host -the monsters lair, dogman -decending the stairwell
	our @Apool_3 = ("Under_The_Skin2", "The_Host4", "Dogman2");
  #++
	#/the wolverine - distant view of b21 aproaching nagasaki bay, the host -the monster aproaches
	our @Apool_4 =	("Wolverine1", "The_Host9", "Terminator2");
  #unique -
	#/
	our @Apool_unique_3 = ();
	
 #palestine - 
  #+
	#/ watchmen -dr manhattan projecting power, the host -the monsters lair
	our @Apool_5 =	("Watchmen2", "The_Host4", "Shin1");
  #++
	#/jarhead -swofford at scene of a war crime, the host -agent yellow, the host -the monster aproaches
	our @Apool_6 =	("Jarhead2", "The_Host5", "The_Host9");
  #+++
	#/...
	our @Apool_7 =	();

 #adversarial nations -
  #+
  	#/watchmen -dr manhattan projecting power, the host -the monsters lair, jarhead -soldier spectating distant oilwell plume
	our @Apool_8 =	("Watchmen2", "The_Host4", "Jarhead3");
  #++	
  	#/
	our @Apool_9 =	();
  #+++
	#/...
	our @Apool_10 =	();
	
 #weapons etc - 
  #+
  	#/jarhead -platoon doing chemical attack drill in the desert, jarhead -soldier spectating distant oilwell plume, the host -agent yellow
	our @Apool_11 =	("Jarhead1", "Jarhead3", "The_Host5");
  #++	
  	#/watchmen -dr manhattan waging war, jarhead -swofford at scene of a war crime, watchmen -dr manhattan accepting vietcong surrender
	our @Apool_12 =	("Watchmen1","Jarhead2", "Watchmen3");
  #+++
	#/...
	our @Apool_13 =	();
	
 #nuclear threat - 
  #+
  	#/watchmen -dr manhattan waging war, the wolverine - distant view of b21 aproaching nagasaki bay, terminator II - close up of children on a playground before a nuclear strike 
	our @Apool_14 =	("Watchmen1", "Wolverine1", "Terminator2");
  #++	
  	#/terminator II - sarah connor desperately grasping fence between a her and the children on a playground before the nuclear strike, the wolverine - distant view of b21 aproaching nagasaki bay
	our @Apool_15 =	("Terminator3", "Wolverine1");
  #+++
	#/...
	our @Apool_16 =	();
	
 #conflict rethoric - 
  #+
  	#/jarhead -soldier spectating distant oilwell plume, the host -agent yellow, watchmen -dr manhattan projecting power
	our @Apool_17 =	("Jarhead3", "The_Host5", "Watchmen2");
  #++	
  	#/watchmen -dr manhattan waging war, jarhead -swofford at scene of a war crime, jarhead -soldiers under hellish oilwell plumes
	our @Apool_18 =	("Watchmen1", "Jarhead2", "Jarhead4");
  #+++
	#/...
	our @Apool_19 =	();

 #context
	#/watchmen -dr manhattan projecting power, jarhead -soldier spectating distant oilwell plume, the wolverine - distant view of b21 aproaching nagasaki bay
	our @Apool_20 =	("Watchmen2","Jarhead3","Wolverine1"); 

 #movie specific pools
 #
 #stepford wives
	#/stepford -opening scene, -facade room, -closing scene.
	our @Apool_movie1 =	("Stepford1", "Stepford2", "Stepford3");
 #dogman
	#/dogman -opening scene, -decending the stairwell, -dead body on playground.
	our @Apool_movie2 =	("Dogman1", "Dogman2", "Dogman3");
 #requiem for a dream
	#/requiem for a dream -seaside pier onset, -seaside pier clearly visible, -seaside pier full view transition, -seaside pier full view but distant, -seaside pier full view but close, -unbeknownst final parting
	our @Apool_movie3 =	("Dream1", "Dream2", "Dream3","Dream4", "Dream5", "Dream6");
 #greenroom
	#/green room -discovery of murder, -neonazi redlaces gathering, -redlaces at the door, -mangled hand
	our @Apool_movie4 =	("Greenroom1", "Greenroom2", "Greenroom3", "Greenroom4");
 #tere will blood
	#/there will be blood -plainview enjoying the sea, -empty bowling alley at plainviews estate, - finished in the bowling alley
	our @Apool_movie5 =	("There_Will_Be_Blood1", "There_Will_Be_Blood2", "There_Will_Be_Blood3");
 #jarhead
	#/jarhead -platoon doing chemical attack drill in the desert, -swofford at scene of a war crime, -soldier spectating distant oilwell plume, -soldiers under hellish oilwell plumes
	our @Apool_movie6 =	("Jarhead1", "Jarhead2", "Jarhead3", "Jarhead4");
#


	
	
	
sub create_groupingA {
	#
	@iraq = (
	##	cluster		object							rating		+ scenearray				++ scenearray	
		["US Wars",	"the Iraqi war & civil war",	"1", 		$Apool_1 [$Arand_three], 	$Apool_2 [$Arand_three]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" iraq ",		"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[1]",	"${$Astat_ref}[1]",	"01:2017:12:2017",	$Apool_2 [2]],
		[" iraq ",		"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[1]",	"${$Astat_ref}[1]",	"01:2018:01:2021",	"null"],
		[" iraqi ",		"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"01:2017:12:2017",	$Apool_2 [2]],
		[" iraqis ",	"$Aword[1]",	"${$Asig_ref}[6]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[3]",	"01:2018:01:2021",	"null"],
		[" iraqi ",		"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"01:2017:12:2017",	$Apool_2 [2]],
		[" iraqis ",	"$Aword[1]",	"${$Asig_ref}[6]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[3]",	"01:2018:01:2021",	"null"],	
		[" baghdad ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[3]",	"01:2017:12:2017",	$Apool_2 [2]],
		[" baghdad ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[3]",	"01:2018:01:2021",	"null"],
		[" isis ", 		"$Aword[1]",	"${$Asig_ref}[7]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[2]",	"01:2017:12:2017",	$Apool_unique_1 [$Arand_three]],
		#["  ",			"$Dword[0]",	"${$Dsig_ref}[0]",	"${$Dfunc_ref}[0]",	"${$Dstat_ref}[0]",	"$Dtime[0]", "null"],
	);
	#
	@afghanistan = (
	##	cluster		object					rating		+ scenearray				++ scenearray
		["US Wars",	"the afghanistan war",	"1",		$Apool_unique_1 [$Arand_three], 	"null"],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" afghanistan ","$Aword[1]","${$Asig_ref}[1]",	"${$Afunc_ref}[1]",	"${$Astat_ref}[1]",	"$Atime[0]", "null"], 
		[" afghani ",	"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],	
		[" kandahar ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[4]",	"${$Astat_ref}[4]",	"$Atime[0]", "null"],	
		[" kabul ",		"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[4]",	"$Atime[0]", "null"],	
		[" taliban ",	"$Aword[1]",	"${$Asig_ref}[7]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],	
	);
	#
	@syria = (
	##	cluster		object					rating		+ scenearray				++ scenearray
		["US Wars",	"the Syrian civil war",	"1", 		$Apool_1 [$Arand_three], 	$Apool_2 [$Arand_three]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" syria ",		"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[1]",	"${$Astat_ref}[1]",	"$Atime[0]", "null"],
		[" syrians ",	"$Aword[1]",	"${$Asig_ref}[6]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[3]",	"$Atime[0]", "null"],	
		[" syrian ",	"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" damascus ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[3]",	"$Atime[0]", "null"],	
		[" assad ",		"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[5]",	"${$Astat_ref}[5]",	"$Atime[0]", "null"],
		[" damascus ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[3]",	"$Atime[0]", "null"],	 	
		[" idlib ",		"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[4]",	"${$Astat_ref}[8]",	"$Atime[0]", "null"],	 	
		[" aleppo ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[4]",	"${$Astat_ref}[8]",	"$Atime[0]", "null"],	 
		[" kurds ",		"$Aword[1]",	"${$Asig_ref}[8]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[7]",	"$Atime[0]", "null"],
		[" isis ", 		"$Aword[1]",	"${$Asig_ref}[7]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[2]",	"01:2017:03:2019", $Apool_unique_1 [$Arand_three]],
		[" isis ", 		"$Aword[1]",	"${$Asig_ref}[7]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[11]","04:2019:01:2021", "null"],
		[" baghdadi ",	"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[6]",	"${$Astat_ref}[2]",	"01:2017:10-2019", $Apool_unique_1 [$Arand_three]],
		[" baghdadi ",	"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[6]",	"${$Astat_ref}[6]",	"11:2019:01-2021", "null"],
		[" the caliphate ","$Aword[1]", "${$Asig_ref}[7]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[2]",	"01:2017:04-2019", $Apool_unique_1 [$Arand_three]],
		[" the caliphate ","$Aword[1]", "${$Asig_ref}[7]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[11]","04:2019:01-2021", "null"],
	);
	#
	@ukraine = (
	##	cluster									object						rating		+ scenearray				++ scenearray
		["wars with indirect US involvement",	"the Russo-Ukrainian war",	"1", 		$Apool_3 [$Arand_three], 	$Apool_4 [$Arand_three]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" ukraine ",	"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[1]",	"${$Astat_ref}[3]",	"$Atime[0]",	"null"],
		[" ukraineians ","$Aword[1]",	"${$Asig_ref}[6]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[3]",	"$Atime[0]",	"null"],
		[" ukraineian ","$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]",	"null"],
		[" crimea ", 	"$Aword[1]",	"${$Asig_ref}[3]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[4]",	"$Atime[0]",	"null"],	
	);
	#
	@palestine = (
	##	cluster									object								rating	+ scenearray			++ scenearray
		["wars with indirect US involvement",	"the Israeli–Palestinian conflict",	"1", 	$Apool_5 [$Arand_three], 	$Apool_6 [$Arand_three]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" gaza ",		"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[1]",	"${$Astat_ref}[4]",	"$Atime[0]", "null"],
		[" palestine ",	"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[1]",	"${$Astat_ref}[4]",	"$Atime[0]", "null"],
		[" palestinians ","$Aword[1]","${$Asig_ref}[8]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[3]",	"$Atime[0]", "null"],
		[" palestinian ","$Aword[2]","${$Asig_ref}[8]",		"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" abbas ",		"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[6]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" hammas ",	"$Aword[1]",	"${$Asig_ref}[7]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" jerusalem ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[3]",	"12:2017:01:2021", $Apool_3 [2]],	 	
	);
	#
	@north_korea = (
	##	cluster				object			rating		+ scenearray				++ scenearray
		["rival nations",	"North Korea",	"1", 		$Apool_14 [$Arand_three], 	$Apool_15 [$Arand_two]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" north korea ","$Aword[1]","${$Asig_ref}[1]",		"${$Afunc_ref}[8]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" noko ",		"$Aword[1]","${$Asig_ref}[1]",		"${$Afunc_ref}[8]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" north korean ","$Aword[2]","${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" north koreans ","$Aword[1]","${$Asig_ref}[6]",	"${$Afunc_ref}[8]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" Pyongyang ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],	
		[" jong un ",	"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[5]",	"${$Astat_ref}[5]",	"$Atime[0]", "null"],
		[" Chairman Kim ","$Aword[1]","${$Asig_ref}[5]",	"${$Afunc_ref}[5]",	"${$Astat_ref}[5]",	"$Atime[0]", "null"],
	);
	#
	@china= (
	##	cluster				object		rating	+ scenearray			++ scenearray
		["rival nations",	"China",	"1", 	$Apool_8 [$Arand_three], 	"null"],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" china ",		"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[8]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" chinese ",	"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" beijing ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],	
		[" the chinese ","$Aword[1]",	"${$Asig_ref}[6]",	"${$Afunc_ref}[8]",	"${$Astat_ref}[3]",	"$Atime[0]", "null"],	
		[" south china sea ","$Aword[1]","${$Asig_ref}[3]","${$Afunc_ref}[7]",	"${$Astat_ref}[4]",	"$Atime[0]", "null"],
		[" president xi ","$Aword[1]","${$Asig_ref}[5]",	"${$Afunc_ref}[5]",	"${$Astat_ref}[5]",	"$Atime[0]", "null"],
		[" xi jinping ","$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[5]",	"${$Astat_ref}[5]",	"$Atime[0]", "null"],
	);
	#
	@russia= (
	##	cluster				object		rating	+ scenearray			++ scenearray
		["rival nations",	"Russia",	"1", 		$Apool_3 [$Arand_three], 	$Apool_4 [$Arand_three]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" russia ",	"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[8]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" russian ",	"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" russians ",	"$Aword[1]",	"${$Asig_ref}[6]",	"${$Afunc_ref}[8]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" moscow ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" putin ",		"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[5]",	"${$Astat_ref}[5]",	"$Atime[0]", "null"],
	);
	#
	@iran = (
	##	cluster				object		rating	+ scenearray			++ scenearray
		["rival nations",	"Iran",		"1", 	$Apool_8 [$Arand_three], 	"null"],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" iran ",		"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[9]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
		[" soleimani ",	"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[10]","${$Astat_ref}[6]",	"01:2020:01:2021", $Apool_14 [1]],
		[" iranian ",	"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" iranians ",	"$Aword[1]",	"${$Asig_ref}[6]",	"${$Afunc_ref}[9]",	"${$Astat_ref}[2]",	"$Atime[0]", "null"],
	);
	#
	@weapons= (
	##	cluster								object					rating	+ scenearray				++ scenearray
		["weapons and military armament",	"conventional weapons",	"1", 	$Apool_11 [$Arand_three], 	$Apool_12 [$Arand_three]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" chemical weapons ","$Aword[6]","${$Asig_ref}[10]","${$Afunc_ref}[11]","${$Astat_ref}[10]","$Atime[0]", $Apool_1 [1]],
		[" chemical attack ","$Aword[6]","${$Asig_ref}[10]","${$Afunc_ref}[11]","${$Astat_ref}[10]","$Atime[0]", $Apool_1 [1]],
		[" bomb ",		"$Aword[5]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" bombs ",		"$Aword[6]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" rocket ",	"$Aword[5]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" rockets ",	"$Aword[6]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" weapon ",	"$Aword[5]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" weapons ",	"$Aword[6]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" drone ",		"$Aword[5]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" drones ",	"$Aword[6]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" tanks ",		"$Aword[6]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" aircraft carrier ","$Aword[5]","${$Asig_ref}[9]","${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
		[" missile ",		"$Aword[5]",	"${$Asig_ref}[9]","${$Afunc_ref}[11]","${$Astat_ref}[9]","$Atime[0]", "null"],
		[" missiles ",	"$Aword[6]",	"${$Asig_ref}[9]",	"${$Afunc_ref}[11]","${$Astat_ref}[9]",	"$Atime[0]", "null"],
	);
	#
	@nuclear_threat = (
	##	cluster				object				rating	+ scenearray	++ scenearray
		["nuclear weapons",	"nuclear weapons",	"1", 	$Apool_14 [$Arand_three], 	$Apool_15 [$Arand_two]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" nato ",		"$Aword[1]",	"${$Asig_ref}[7]", 	"${$Afunc_ref}[3]",	"${$Astat_ref}[2]",	"$Atime[0]", $Apool_1 [$Arand_two]],
		[" nuclear ",	"$Aword[2]",	"${$Asig_ref}[11]",	"${$Afunc_ref}[12]","${$Astat_ref}[10]","$Atime[0]", "null"],
		[" nuke ",		"$Aword[5]",	"${$Asig_ref}[11]",	"${$Afunc_ref}[12]","${$Astat_ref}[10]","$Atime[0]", "null"],
		[" nukes ",		"$Aword[6]",	"${$Asig_ref}[11]",	"${$Afunc_ref}[12]","${$Astat_ref}[10]","$Atime[0]", "null"],
		[" plutonium ",	"$Aword[5]",	"${$Asig_ref}[13]",	"${$Afunc_ref}[13]","${$Astat_ref}[10]","$Atime[0]", "null"],
		[" uranium ",	"$Aword[5]",	"${$Asig_ref}[13]",	"${$Afunc_ref}[13]","${$Astat_ref}[10]","$Atime[0]", "null"],
	);
	#
	@conflict_rhetoric = (
	##	cluster						object					rating	+ scenearray				++ scenearray
		["context and rhetoric",	"conflict rhetoric",	"1", 	$Apool_17 [$Arand_three], 	$Apool_18 [$Arand_three]],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" make america strong again ","$Aword[7]","${$Asig_ref}[1]","${$Afunc_ref}[0]","${$Astat_ref}[0]","$Atime[0]", "null"],
		[" makeamericastrongagain ",  "$Aword[7]","${$Asig_ref}[1]","${$Afunc_ref}[0]","${$Astat_ref}[0]","$Atime[0]", "null"],
		[" provocation ","$Aword[3]","${$Asig_ref}[12]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" retribution ","$Aword[3]","${$Asig_ref}[12]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", $Apool_2 [$Arand_three]],
		[" bombing ",	"$Aword[3]",	"${$Asig_ref}[12]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", $Apool_2 [$Arand_three]],
		[" the strike ","$Aword[3]",	"${$Asig_ref}[12]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", $Apool_2 [$Arand_three]],
	);
	#
	@Acontext = (
	##	cluster						object		rating		+ scenearray				++ scenearray
		["context and rhetoric",	"context",	"2", 		$Apool_20 [$Arand_three], 	"null"],
	#	
	##	0 match			1 wordtype		 2 signification	3 function			4 status			5 timeperiod	+++ scenearray	
		[" attack ",	"$Aword[3]",	"${$Asig_ref}[12]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", $Apool_2 [$Arand_three]],
		[" conflict ",	"$Aword[3]",	"${$Asig_ref}[12]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", $Apool_2 [$Arand_three]],
		[" defense ",	"$Aword[3]",	"${$Asig_ref}[14]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" israel ",	"$Aword[1]",	"${$Asig_ref}[1]",	"${$Afunc_ref}[3]",	"${$Astat_ref}[7]",	"$Atime[0]", "null"],
		[" netanyahu ",	"$Aword[1]",	"${$Asig_ref}[5]",	"${$Afunc_ref}[14]","${$Astat_ref}[5]",	"$Atime[0]", "null"],
		[" Israeli ",	"$Aword[2]",	"${$Asig_ref}[2]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", "null"],
		[" embassy ",	"$Aword[1]",	"${$Asig_ref}[3]",	"${$Afunc_ref}[0]",	"${$Astat_ref}[0]",	"$Atime[0]", $Apool_3 [2]],
		[" jerusalem ",	"$Aword[1]",	"${$Asig_ref}[4]",	"${$Afunc_ref}[2]",	"${$Astat_ref}[0]",	"01:2017:11:2017", $Apool_3 [2]],	 
	);
	#
};
sub create_groupingAv{
	$Asig_ref 	= \@Asigval;
	$Afunc_ref	= \@Afuncval;
	$Astat_ref	= \@Astatval;
	
	create_groupingA;
	
	our $Acontext_val_ref  = \@Acontext;
	our $conflict_rhetoric_val_ref  = \@conflict_rhetoric;
	our $nuclear_threat_val_ref  = \@nuclear_threat;
	our $weapons_val_ref  = \@weapons;
	our $iran_val_ref  = \@iran;
	our $russia_val_ref  = \@russia;
	our $china_val_ref  = \@china;
	our $north_korea_val_ref  = \@north_korea;
	our $palestine_val_ref  = \@palestine;
	our $ukraine_val_ref  = \@ukraine;
	our $syria_val_ref  = \@syria;
	our $afghanistan_val_ref  = \@afghanistan;
	our $iraq_val_ref  = \@iraq;
	
	our @valuesA = ($iraq_val_ref, $afghanistan_val_ref, $syria_val_ref,  $ukraine_val_ref,  $palestine_val_ref,  $north_korea_val_ref,  $china_val_ref, $russia_val_ref,  $iran_val_ref,  $weapons_val_ref,  $nuclear_threat_val_ref,  $conflict_rhetoric_val_ref,	$Acontext_val_ref);
};
sub create_groupingAo{
	
	$Asig_ref 	= \@Asig;
	$Afunc_ref	= \@Afunc;
	$Astat_ref	= \@Astat;
	
	create_groupingA;
	
	our $Acontext_ref  = \@Acontext;
	our $conflict_rhetoric_ref  = \@conflict_rhetoric;
	our $nuclear_threat_ref  = \@nuclear_threat;
	our $weapons_ref  = \@weapons;
	our $iran_ref  = \@iran;
	our $russia_ref  = \@russia;
	our $china_ref  = \@china;
	our $north_korea_ref  = \@north_korea;
	our $palestine_ref  = \@palestine;
	our $ukraine_ref  = \@ukraine;
	our $syria_ref  = \@syria;
	our $afghanistan_ref  = \@afghanistan;
	our $iraq_ref  = \@iraq;
	
	our @objectsA = ($iraq_ref, $afghanistan_ref, $syria_ref,  $ukraine_ref,  $palestine_ref,  $north_korea_ref,  $china_ref, $russia_ref,  $iran_ref,  $weapons_ref,  $nuclear_threat_ref,  $conflict_rhetoric_ref,	$Acontext_ref);
#print Dumper @objectsA;
};

#create_groupingAo;
1;
END
