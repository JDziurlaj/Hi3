/*
The MIT License (MIT)

Copyright (c) 2014 John Dziurlaj

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
grammar hi3;

options {
    memoize=true;
    k=5;
    output=AST;
}
//Sets Required for USPS 

//tokens for AST output
tokens{
	ADDRESS;
	COMPLETE_ADDRESS_NUMBER;
	ADDRESS_NUMBER_PREFIX;
	ADDRESS_NUMBER;
	ADDRESS_NUMBER_SUFFIX;
	COMPLETE_STREET_NAME;
	STREET_NAME_PRE_MODIFIER;
	STREET_NAME_PRE_DIRECTIONAL;
	STREET_NAME_PRE_TYPE;
	STREET_NAME;
	STREET_NAME_POST_TYPE;
	STREET_NAME_POST_DIRECTIONAL;
	STREET_NAME_POST_MODIFIER;
	SUBADDRESS;
	SUBADDRESS_TYPE;
	SUBADDRESS_IDENTIFIER;	
}
@parser::header
{
import java.util.LinkedList;
}
@lexer::header
{
import java.util.LinkedList;
}
@parser::members {
    private List<String> errors = new LinkedList<String>();
    public void displayRecognitionError(String[] tokenNames,
                                        RecognitionException e) {
        String hdr = getErrorHeader(e);
        String msg = getErrorMessage(e, tokenNames);
        errors.add(hdr + " " + msg);
    }
    public List<String> getErrors() {
        return errors;
    }
}
@lexer::members {
    /* http://stackoverflow.com/questions/8797484/antlr-lexer-tokens-that-match-similar-strings-what-if-the-greedy-lexer-makes-a/8800722#8800722 */
    private boolean ahead(String text) {
        for(int i = 0; i < text.length(); i++) {
          if(input.LA(i + 1) != text.charAt(i)) {
            return false;
         }
       }
       return true;
     }
     //ahead for Street Name Pre Types
      private boolean ahead_pt(String text) {
	int i = 0;
      //get all the string we need
        for(; i < text.length(); i++) {
	  System.out.println(input.LA(i + 1) + "!=" + text.charAt(i));
          if(input.LA(i + 1) != text.charAt(i)) {          
            //not the string we need
            return false;
         }
       }
       //done getting the string, now accept any add'l letter(s) until we get a space
       //let's stop at 400, no address should be that long!
       for(; i < 400; i++)
       {
        //get current input
       	int ch =  input.LA(i + 1);
       	//short circuit if we get -1, means <EOF>!
       	if(ch == -1)
            return false;
       	//http://docs.oracle.com/javase/tutorial/i18n/text/charintro.html
       	if(!((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch == ' ')))
       	{
	   
   	   return false;
       	}
       	//check if we got a space!
       	if(ch == ' ')
       	{ //next char must be a number!
	       	ch =  input.LA(++i + 1);
       		if(ch >= '0' && ch <= '9')
       		{
       			return true;
       		}
       		else
       		{       //we didn't get a SPACE followed by a number, so it is not a Street Name Pre Type!
       			return false;
       		}
       	}

       }
       //went 400 characters and 
       return false;
     }
    private List<String> errors = new LinkedList<String>();
    public void displayRecognitionError(String[] tokenNames,
                                        RecognitionException e) {
        String hdr = getErrorHeader(e);
        String msg = getErrorMessage(e, tokenNames);
        errors.add(hdr + " " + msg);
    }
    public List<String> getErrors() {
        return errors;
    }
}

Suffixes : ('ALLEE'|'ALLEY'|'ALLY'|'ALY'|'ANEX'|'ANNEX'|'ANNX'|'ANX'|'ARC'|'ARCADE'|'AV'|'AVE'|'AVEN'|'AVENU'|'AVENUE'|'AVN'|'AVNUE'|'BAYOO'|'BAYOU'|'BCH'|'BEACH'|'BEND'|'BND'|'BLF'|'BLUF'|'BLUFF'|'BLUFFS'|'BOT'|'BOTTM'|'BOTTOM'|'BTM'|'BLVD'|'BOUL'|'BOULEVARD'|'BOULV'|'BR'|'BRANCH'|'BRNCH'|'BRDGE'|'BRG'|'BRIDGE'|'BRK'|'BROOK'|'BROOKS'|'BURG'|'BURGS'|'CAMP'|'CMP'|'CP'|'CANYN'|'CANYON'|'CNYN'|'CYN'|'CAPE'|'CPE'|'CAUSEWAY'|'CAUSWAY'|'CSWY'|'CEN'|'CENT'|'CENTER'|'CENTR'|'CENTRE'|'CNTER'|'CNTR'|'CTR'|'CENTERS'|'CIR'|'CIRC'|'CIRCL'|'CIRCLE'|'CRCL'|'CRCLE'|'CIRCLES'|'CLF'|'CLIFF'|'CLFS'|'CLIFFS'|'CLB'|'CLUB'|'COMMON'|'COR'|'CORNER'|'CORNERS'|'CORS'|'COURSE'|'CRSE'|'COURT'|'CRT'|'CT'|'COURTS'|'CTS'|'COVE'|'CV'|'COVES'|'CK'|'CR'|'CREEK'|'CRK'|'CRECENT'|'CRES'|'CRESCENT'|'CRESENT'|'CRSCNT'|'CRSENT'|'CRSNT'|'CREST'|'CROSSING'|'CRSSING'|'CRSSNG'|'XING'|'CROSSROAD'|'CURVE'|'DALE'|'DL'|'DAM'|'DM'|'DIV'|'DIVIDE'|'DV'|'DVD'|'DR'|'DRIV'|'DRIVE'|'DRV'|'DRIVES'|'EST'|'ESTATE'|'ESTATES'|'ESTS'|'EXP'|'EXPR'|'EXPRESS'|'EXPW'|'EXPY'|'EXT'|'EXTENSION'|'EXTN'|'EXTNSN'|'EXTENSIONS'|'EXTS'|'FALL'|'FALLS'|'FLS'|'FERRY'|'FRRY'|'FRY'|'FIELD'|'FLD'|'FIELDS'|'FLDS'|'FLAT'|'FLT'|'FLATS'|'FLTS'|'FORD'|'FRD'|'FORDS'|'FOREST'|'FORESTS'|'FRST'|'FORG'|'FORGE'|'FRG'|'FORGES'|'FORK'|'FRK'|'FORKS'|'FRKS'|'FORT'|'FRT'|'FT'|'FREEWAY'|'FREEWY'|'FRWAY'|'FRWY'|'FWY'|'GARDEN'|'GARDN'|'GDN'|'GRDEN'|'GRDN'|'GARDENS'|'GDNS'|'GRDNS'|'GATEWAY'|'GATEWY'|'GATWAY'|'GTWAY'|'GTWY'|'GLEN'|'GLN'|'GLENS'|'GREEN'|'GRN'|'GREENS'|'GROV'|'GROVE'|'GRV'|'GROVES'|'HARB'|'HARBOR'|'HARBR'|'HBR'|'HRBOR'|'HARBORS'|'HAVEN'|'HAVN'|'HVN'|'HEIGHT'|'HEIGHTS'|'HGTS'|'HT'|'HTS'|'HILL'|'HL'|'HILLS'|'HLS'|'HLLW'|'HOLLOW'|'HOLLOWS'|'HOLW'|'HOLWS'|'INLET'|'INLT'|'IS'|'ISLAND'|'ISLND'|'ISLANDS'|'ISLNDS'|'ISS'|'ISLE'|'ISLES'|'JCT'|'JCTION'|'JCTN'|'JUNCTION'|'JUNCTN'|'JUNCTON'|'JCTNS'|'JCTS'|'JUNCTIONS'|'KEY'|'KY'|'KEYS'|'KYS'|'KNL'|'KNOL'|'KNOLL'|'KNLS'|'KNOLLS'|'LAKE'|'LK'|'LAKES'|'LKS'|'LAND'|'LANDING'|'LNDG'|'LNDNG'|'LA'|'LANE'|'LANES'|'LN'|'LGT'|'LIGHT'|'LIGHTS'|'LF'|'LOAF'|'LCK'|'LOCK'|'LCKS'|'LOCKS'|'LDG'|'LDGE'|'LODG'|'LODGE'|'LOOPS'|'MALL'|'MANOR'|'MNR'|'MANORS'|'MNRS'|'MDW'|'MEADOW'|'MDWS'|'MEADOWS'|'MEDOWS'|'MEWS'|'MILL'|'ML'|'MILLS'|'MLS'|'MISSION'|'MISSN'|'MSN'|'MSSN'|'MOTORWAY'|'MNT'|'MOUNT'|'MT'|'MNTAIN'|'MNTN'|'MOUNTAIN'|'MOUNTIN'|'MTIN'|'MTN'|'MNTNS'|'MOUNTAINS'|'NCK'|'NECK'|'ORCH'|'ORCHARD'|'ORCHRD'|'OVAL'|'OVL'|'OVERPASS'|'PARK'|'PK'|'PRK'|'PARKS'|'PARKWAY'|'PARKWY'|'PKWAY'|'PKWY'|'PKY'|'PARKWAYS'|'PKWYS'|'PASS'|'PASSAGE'|'PATH'|'PATHS'|'PIKE'|'PIKES'|'PINE'|'PINES'|'PNES'|'PL'|'PLACE'|'PLAIN'|'PLN'|'PLAINES'|'PLAINS'|'PLNS'|'PLAZA'|'PLZ'|'PLZA'|'POINT'|'PT'|'POINTS'|'PTS'|'PORT'|'PRT'|'PORTS'|'PRTS'|'PR'|'PRAIRIE'|'PRARIE'|'PRR'|'RAD'|'RADIAL'|'RADIEL'|'RADL'|'RAMP'|'RANCH'|'RANCHES'|'RNCH'|'RNCHS'|'RAPID'|'RPD'|'RAPIDS'|'RPDS'|'REST'|'RST'|'RDG'|'RDGE'|'RIDGE'|'RDGS'|'RIDGES'|'RIV'|'RIVER'|'RIVR'|'RVR'|'ROAD'|'RDS'|'ROADS'|'ROW'|'RUE'|'RUN'|'SHL'|'SHOAL'|'SHLS'|'SHOALS'|'SHOAR'|'SHORE'|'SHR'|'SHOARS'|'SHORES'|'SHRS'|'SKYWAY'|'SPG'|'SPNG'|'SPRING'|'SPRNG'|'SPGS'|'SPNGS'|'SPRINGS'|'SPRNGS'|'SPUR'|'SPURS'|'SQ'|'SQR'|'SQRE'|'SQU'|'SQUARE'|'SQRS'|'SQUARES'|'STATION'|'STATN'|'STN'|'STRA'|'STRAV'|'STRAVE'|'STRAVEN'|'STRAVENUE'|'STRAVN'|'STRVN'|'STRVNUE'|'STREAM'|'STREME'|'STRM'|'ST'|'STR'|'STREET'|'STRT'|'STREETS'|'SMT'|'SUMIT'|'SUMITT'|'SUMMIT'|'TER'|'TERR'|'TERRACE'|'THROUGHWAY'|'TRACE'|'TRACES'|'TRCE'|'TRACK'|'TRACKS'|'TRAK'|'TRK'|'TRKS'|'TRAFFICWAY'|'TRFY'|'TR'|'TRAIL'|'TRAILS'|'TRL'|'TRLS'|'TUNEL'|'TUNL'|'TUNLS'|'TUNNEL'|'TUNNELS'|'TUNNL'|'TPK'|'TPKE'|'TRNPK'|'TRPK'|'TURNPIKE'|'TURNPK'|'UNDERPASS'|'UN'|'UNION'|'UNIONS'|'VALLEY'|'VALLY'|'VLLY'|'VLY'|'VALLEYS'|'VLYS'|'VDCT'|'VIA'|'VIADCT'|'VIADUCT'|'VIEW'|'VW'|'VIEWS'|'VWS'|'VILL'|'VILLAG'|'VILLAGE'|'VILLG'|'VILLIAGE'|'VLG'|'VILLAGES'|'VLGS'|'VILLE'|'VL'|'VIS'|'VIST'|'VISTA'|'VST'|'VSTA'|'WALK'|'WALKS'|'WALL'|'WAY'|'WY'|'WAYS'|'WELL'|'WELLS'|'WLS'|'JUMP'|'CHASE'|'RESERVE'|'GATE'|'CROSS'|'END'|'GLORY'|'POINTE');
//Highways
//Anything with a space will require a semantic predicate :(
//NO KY IN HIGHWAYS//

//Semantic Predicate for STATE ROUTE must be spelled out to ensure it does not match STATE ROAD or something else
//ST RT is spelled out to avoid ST RACHEL (as in Saint)
StateRoute : {ahead_pt("ST R")||ahead_pt("STATE R")||ahead_pt("SR MM")}?
		=> ('STATE' SPACE 'ROUTE'|'STATE' SPACE 'RTE'|'STATE' SPACE 'RT'|
		//sr
		//'SR'
		//sr m
		'SR' SPACE 'MM'|
		//st rt
		'ST' SPACE 'ROUTE'|'ST' SPACE 'RT'|'ST' SPACE 'RTE'); 
		
UsHighway : {ahead_pt("US HI")||ahead_pt("US HW")}?
		=> ('US' SPACE 'HIGHWAY'|'US' SPACE 'HIGHWY'|'US' SPACE 'HIWAY'|'US' SPACE 'HIWY'
		//us hi
		|'US' SPACE 'HWAY'|'US' SPACE 'HWY'); 
		
CountyHighway : {ahead_pt("COUNTY HI")||ahead_pt("CNTY HI")||ahead_pt("COUNTY HW")||ahead_pt("CNTY HW")}?
		=> ('COUNTY' SPACE 'HIGHWAY'|'COUNTY' SPACE 'HIGHWY'|'COUNTY' SPACE 'HIWAY'|'COUNTY' SPACE 'HIWY'|'COUNTY' SPACE 'HWAY'|'COUNTY' SPACE 'HWY'
		//cnty h
		|'CNTY' SPACE 'HIGHWAY'|'CNTY' SPACE 'HIGHWY'|'CNTY' SPACE 'HIWAY'|'CNTY' SPACE 'HIWY'|'CNTY' SPACE 'HWAY'|'CNTY' SPACE 'HWY');		
		
CountyRoad : {ahead_pt("COUNTY R")||ahead_pt("CNTY R")||ahead_pt("CR")||ahead_pt("CO R")}? 
		=> ('COUNTY ROAD'|'COUNTY RD'
		//cnty r
		|'CNTY' SPACE 'ROAD'|'CNTY' SPACE 'RD'
		//cr
		|'CR'
		//co rd - added per lawrence county
		|'CO RD'
		);

//CaliforniaCountyRoad : ('CA' SPACE 'COUNTY' SPACE 'RD'|'CALIFORNIA' SPACE 'COUNTY' SPACE 'ROAD');

FM : {ahead_pt("FM")||ahead_pt("FARM TO MARKET")}? 
		=> ('FM'|'FARM' SPACE 'TO' SPACE 'MARKET');
		
RanchRoad :  {ahead_pt("RANCH R")|ahead_pt("RNCH R")}? 
		=> ('RANCH' SPACE 'RD'|'RANCH' SPACE 'ROAD'
		//rnch r
		|'RNCH' SPACE 'ROAD');
		
StateHighway : {ahead_pt("STATE H")||ahead_pt("ST H")}? 
		=> ('STATE' SPACE 'HIGHWAY'|'STATE' SPACE 'HIGHWY'|'STATE' SPACE 'HIWAY'|'STATE' SPACE 'HIWY'|'STATE' SPACE 'HWAY'|'STATE' SPACE 'HWY'
		//st h
		|'ST' SPACE 'HIGHWAY'|'ST' SPACE 'HIGHWY'|'ST' SPACE 'HIWAY'|'ST' SPACE 'HIWY'|'ST' SPACE 'HWAY''ST' SPACE 'HWY');
		
StateRoad : {ahead_pt("STATE R")||ahead_pt("ST R")/*||ahead_pt("SR")*/}? 
		=> ('STATE' SPACE 'ROAD'|'STATE' SPACE 'RD'
		//st r
		|'ST' SPACE 'RD'|'ST' SPACE 'ROAD'
		//sr
//		|'SR'
		);		
		
TownshipRoad : {ahead_pt("TOWNSHIP R")||ahead_pt("TWP R")||ahead_pt("TSR")}? 
		=> ('TOWNSHIP' SPACE 'RD'|'TOWNSHIP' SPACE 'ROAD'|
		//twp r
			'TWP' SPACE 'ROAD'|'TWP' SPACE 'RD'
		//tsr
			|'TSR');

//KentuckyHighway : ('KY HIGHWAY'|'KENTUCKY'|'KENTUCKY' SPACE 'HIGHWAY'|'KY' SPACE 'HWY');
//KentuckyStateHighway : ('KY' SPACE 'ST' SPACE 'HWY'|'KY' SPACE 'STATE' SPACE 'HIGHWAY');

//HighwaysConcat : ('I'|'IH');
HighwaysFirst : {ahead_pt("INTERSTATE")||ahead_pt("HWY FM")}?  
		=> ('INTERSTATE' SPACE 'HWY'|'HWY' SPACE 'FM'|'INTERSTATE');

HighwaysFollow : {ahead_pt("FRONTAGE R")}? 
		=> ('FRONTAGE' SPACE 'RD');//|'BYPASS' SPACE 'RD'); 

//Tokens shared by more than one class
SuffixHighwayUnion 
	:	 ('EXPRESSWAY'|'RD'|'RTE'|'ROUTE'|'LOOP')                   ;
SuffixHighwayFirstUnion 
	:	 ('HIGHWAY'|'HIGHWY'|'HIWAY'|'HIWY'|'HWAY'|'HWY');
SuffixHighwayFollowUnion 
	:	 ('BYP'|'BYPA'|'BYPAS'|'BYPASS'|'BYPS');
    
//Designators
StandardSecondaryAddressIdentifier: ('APARTMENT'|'APT'|'BUILDING'|'BLDG'|'DEPARTMENT'|'DEPT'|'FLOOR'|'FL'|'HANGER'|'HNGR'|'KEY'|'LOT'|'PIER'|'ROOM'|'RM'|'SLIP'|'SPACE'|'SPC'|'STOP'|'SUITE'|'STE'|'TRAILER'|'TRLR'|'UNIT');
ExtendedSecondaryAddressIdentifier : ('BASEMENT'|'BSMT'|'FRONT'|'FRNT'|'LOBBY'|'LBBY'|'LOWER'|'LOWR'|'OFFICE'|'OFC'|'PENTHOUSE'|'PH'|'REAR'|'SIDE'|'UPPER'|'UPPR');



AbbreviatedDirectional :  ('N'|'S'|'E'|'W'|'NW'|'NE'|'SW'|'SE')
	;
Directional 
	:	 ('NORTH'|'SOUTH'|'EAST'|'WEST'|'NORTHWEST'|'NORTHEAST'|'SOUTHWEST'|'SOUTHEAST')
	;
SpacedDirectional
	: {ahead_pt("NORTH WEST")||ahead_pt("NORTH EAST")||ahead_pt("SOUTH WEST")||ahead_pt("SOUTH EAST")}?
		=> ('NORTH' SPACE 'WEST'|'NORTH' SPACE 'EAST'|'SOUTH' SPACE 'WEST'|'SOUTH' SPACE 'EAST');

PreModifier
	:	('OLD'|'ALTERNATE')
	;

directional
	: Directional
	| AbbreviatedDirectional
	| SpacedDirectional
	;
	
Letters : ('a'..'z'|'A'..'Z')+;
Numbers : '0' .. '9'+ ;
NEWLINE: ('\r'? '\n')+;
DASH	:	 '-';
SPACE : (' ')+;



// ------------------------------------------------- Rules
start 	:	address 
	;
address : ((completeAddressNumber) SPACE (completeStreetName) (SPACE (completeSubaddress))?) 
		-> ^(ADDRESS completeAddressNumber completeStreetName (completeSubaddress)?)		
	;

//Ref USPS28 Primary addressNumber
//FGDC-STD-016-2011 2.2.1.4
completeAddressNumber : addressNumber ((SPACE)? addressNumberSuffix | concatenatedAddressNumberSuffix)?  
                      	-> ^(COMPLETE_ADDRESS_NUMBER addressNumber (SPACE)? (addressNumberSuffix)? (concatenatedAddressNumberSuffix)?)                                              
                      //prefix, number any maybe suffix
                      | addressNumberPrefix SPACE addressNumber ((SPACE)? addressNumberSuffix| concatenatedAddressNumberSuffix)? 
                      	-> ^(COMPLETE_ADDRESS_NUMBER addressNumberPrefix addressNumber (SPACE)? (addressNumberSuffix)? (concatenatedAddressNumberSuffix)?) 
		      ;
//Numeric only per FGDC
addressNumber : Numbers 
		-> ^(ADDRESS_NUMBER Numbers)
	      ;
number : Numbers
       ;
//Only USPS Profile Supported 28 Sec. D1, D3
addressNumberPrefix  : Letters (lettersOrNumbers)?
			-> ^(ADDRESS_NUMBER_PREFIX Letters (lettersOrNumbers)?)
                     | addressNumber seperator addressNumber //Only Valid if SPACE Exists
                     	-> ^(ADDRESS_NUMBER_PREFIX addressNumber seperator addressNumber)
       		     ;             

//Required to eliminated shift-reduce conflict
concatenatedAddressNumberPrefix : Letters ((lettersOrNumbers)? seperator)?
					-> ^(ADDRESS_NUMBER_PREFIX Letters ((lettersOrNumbers)? seperator)?)                         
			        ;                              
//Only USPS Profile Supported 28 Sec. D4
addressNumberSuffix : Numbers '/' Numbers    
			-> ^(ADDRESS_NUMBER_SUFFIX Numbers '/' Numbers)                                  
		    ;
concatenatedAddressNumberSuffix : Letters (lettersOrNumbers)? 
					-> ^(ADDRESS_NUMBER_SUFFIX  Letters (lettersOrNumbers)?)                                
                               	| seperator Numbers '/' Numbers 
					-> ^(ADDRESS_NUMBER_SUFFIX Numbers '/' Numbers)
				;
//suffixes may end up beign in an address name. E.g. STate has ST in it. 21RD has RD in it.
//addressLettersOrNumbers : (suffix)?lettersOrNumbers(suffix)? (DASH (suffix)?lettersOrNumbers(suffix)?)?
//	;
addressLettersOrNumbers : (suffix)?lettersOrNumbers(suffix)? (DASH (suffix)?lettersOrNumbers(suffix)?)?
			;
lettersOrNumbers : Numbers (lettersOrNumbers)?
                 | Letters (lettersOrNumbers)?
                 ;

//End Section
seperator : DASH
	  ;
//****************
//StreetName
//****************

completeStreetName : ((streetNamePreDirectional SPACE)?  streetNamePreType SPACE ((streetName|specialStreetName) streetNamePostModifier) (SPACE streetNamePostDirectional)?)
             		=> (streetNamePreDirectional SPACE)? streetNamePreType SPACE ((streetName|specialStreetName) streetNamePostModifier) (SPACE streetNamePostDirectional)?
                  		-> ^(COMPLETE_STREET_NAME (streetNamePreDirectional)?  streetNamePreType ^(STREET_NAME (streetName)? (specialStreetName)?) (streetNamePostModifier)? (streetNamePostDirectional)?)
                   | (streetNamePreModifier SPACE)? (streetNamePreDirectional SPACE)? streetNamePreType (SPACE Numbers (SPACE streetNamePostDirectional)?)
	                   -> ^(COMPLETE_STREET_NAME (streetNamePreModifier)? (streetNamePreDirectional)?  streetNamePreType ^(STREET_NAME (Numbers)?) (streetNamePostDirectional)?)
		   |  ((streetNamePreModifier SPACE)? streetNamePreDirectional SPACE (streetName|specialStreetName) streetNamePostModifier)
			=> (streetNamePreModifier SPACE)? streetNamePreDirectional SPACE (streetName|specialStreetName) streetNamePostModifier (SPACE streetNamePostDirectional)?
				-> ^(COMPLETE_STREET_NAME (streetNamePreModifier)? streetNamePreDirectional  ^(STREET_NAME (streetName)? (specialStreetName)?) streetNamePostModifier (streetNamePostDirectional)?)
		   | ((streetName|specialStreetName) streetNamePostModifier) 
			=> (streetName|specialStreetName) streetNamePostModifier (SPACE streetNamePostDirectional)?
        			-> ^(COMPLETE_STREET_NAME  ^(STREET_NAME  (streetName)? (specialStreetName)?) streetNamePostModifier (streetNamePostDirectional)?)                
                
		   ;
//232,233 (partial)
//edge case of 212 21ST AVE (ST is SUFFIX, binds closer than addressLettersOrNumbers
//streetName : addressLettersOrNumbers SPACE(streetName | specialStreetName)?	
streetName : addressLettersOrNumbers (SPACE (streetName | specialStreetName)?)
           ;       

specialStreetName  : highway SPACE (streetName|specialStreetName)?       		   
		   | directional SPACE (streetName|specialStreetName)?
                   | suffix SPACE (streetName|specialStreetName)?   
                   | PreModifier SPACE (streetName|specialStreetName)?   
                   ;

streetNamePreModifier 
	:	PreModifier
		-> ^(STREET_NAME_PRE_MODIFIER PreModifier)
	;                   
                   
                   
//237
streetNamePreType : union
			-> ^(STREET_NAME_PRE_TYPE union)
                  | highway 
                  	-> ^(STREET_NAME_PRE_TYPE highway)
                  | highwayFirst SPACE highwayFollow 
                  	-> ^(STREET_NAME_PRE_TYPE highwayFirst SPACE highwayFollow)
	          ;
//233.2

//233.21
//Ambiguties in Directionals:
// i(South East|Southeast) should be translated into SE.

streetNamePreDirectional : directional
				-> ^(STREET_NAME_PRE_DIRECTIONAL directional)
	                 ;
streetNamePostDirectional : directional
				-> ^(STREET_NAME_POST_DIRECTIONAL directional)
	                  ;
streetNamePostModifier : suffix    
				-> ^(STREET_NAME_POST_MODIFIER suffix)  
                       ;              
//Support Production
suffix : Suffixes
       | SuffixHighwayUnion
       | SuffixHighwayFirstUnion
       | SuffixHighwayFollowUnion
       ;
//NUMBER at end of highway not part of Highway per FGDC
highway : StateRoute 
        | UsHighway 
        | CountyHighway 
        | CountyRoad 
        | FM 
        | RanchRoad 
        | StateHighway 
        | StateRoad 
        | TownshipRoad  
	;
union 	: SuffixHighwayUnion
        | SuffixHighwayFirstUnion
        | SuffixHighwayFollowUnion
        ;

highwayFirst : HighwaysFirst Numbers
             |  SuffixHighwayFirstUnion Numbers
	     ;
highwayFollow : HighwaysFollow
              | SuffixHighwayFollowUnion
	      ;
//****************
//Subaddress
//****************
//18.213
completeSubaddress : poundBasedSubaddressType 
			-> ^(SUBADDRESS poundBasedSubaddressType)
                   | abbreviatedSubaddressType
      			-> ^(SUBADDRESS abbreviatedSubaddressType)
		   ;
//18.213.2
poundBasedSubaddressType : '#' lettersOrNumbers
				-> ^(SUBADDRESS_IDENTIFIER lettersOrNumbers)
                         | '#' SPACE lettersOrNumbers
      				-> ^(SUBADDRESS_IDENTIFIER lettersOrNumbers)
			 ;
//18.213.1
abbreviatedSubaddressType : StandardSecondaryAddressIdentifier SPACE subaddressIdentifier
				-> ^(SUBADDRESS_TYPE StandardSecondaryAddressIdentifier) ^(SUBADDRESS_IDENTIFIER subaddressIdentifier)?
                          | ExtendedSecondaryAddressIdentifier
	                        -> ^(SUBADDRESS_TYPE ExtendedSecondaryAddressIdentifier)
                          | ExtendedSecondaryAddressIdentifier SPACE subaddressIdentifier
	                        -> ^(SUBADDRESS_TYPE ExtendedSecondaryAddressIdentifier) ^(SUBADDRESS_IDENTIFIER subaddressIdentifier)
			  ;
//street name gives us most flexibility here, may want to make seperate productions if we want special logic.			 
subaddressIdentifier : /*(addressLettersOrNumbers | directional) (subaddressIdentifier)?
				=> */(addressLettersOrNumbers | directional) (directional)?			
		     ;
 
