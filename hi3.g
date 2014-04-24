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
       	{ 
       
       	//next char must be a number!
	    	ch =  input.LA(++i + 1);
       		if(ch >= '0' && ch <= '9')
       		{
       			return true;
       		}
       		//we could have a case where the following input is presented:
       		//1 STATE RD N
       		//in this case we want to parse STATE RD as the Street Name
       		//and N as the post directional       		
       		else if(ch != 'N' && ch != 'S' && ch != 'E' && ch != 'W' && ch != '#')
       		{
	       		ch =  input.LA(++i + 1);
	       		//now look for a space
	       		//we can't allow two character street names in this context
	       		//as we might cause a mismatch with a secondary unit type. 
	       		//e.g. PH, RM, etc.
       			if(ch == ' ' || ch == 'E' || ch == 'W' || ch == -1)
		       		return true;
		       	else
		       		return false;
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
/* USPS Pub 28 used as domain */
Suffixes : ('ALLEE'|'ALLEY'|'ALLY'|'ALY'|'ANEX'|'ANNEX'|'ANNX'|'ANX'|'ARC'|'ARCADE'|'AV'|'AVE'|'AVEN'|'AVENU'|'AVENUE'|'AVN'|'AVNUE'|'BAYOO'|'BAYOU'|'BCH'|'BEACH'|'BEND'|'BLF'|'BLUF'|'BLUFF'|'BLUFFS'|'BLVD'|'BND'|'BOT'|'BOTTM'|'BOTTOM'|'BOUL'|'BOULEVARD'|'BOULV'|'BR'|'BRANCH'|'BRDGE'|'BRG'|'BRIDGE'|'BRK'|'BRNCH'|'BROOK'|'BROOKS'|'BTM'|'BURG'|'BURGS'|'CAMP'|'CANYN'|'CANYON'|'CAPE'|'CAUSEWAY'|'CAUSWA'|'CAUSWAY'|'CEN'|'CENT'|'CENTER'|'CENTERS'|'CENTR'|'CENTRE'|'CIR'|'CIRC'|'CIRCL'|'CIRCLE'|'CIRCLES'|'CK'|'CLB'|'CLF'|'CLFS'|'CLIFF'|'CLIFFS'|'CLUB'|'CMP'|'CNTER'|'CNTR'|'CNYN'|'COMMON'|'COMMONS'|'COR'|'CORNER'|'CORNERS'|'CORS'|'COURSE'|'COURT'|'COURTS'|'COVE'|'COVES'|'CP'|'CPE'|'CR'|'CRCL'|'CRCLE'|'CRECENT'|'CREEK'|'CRES'|'CRESCENT'|'CRESENT'|'CREST'|'CRK'|'CROSSING'|'CROSSROAD'|'CROSSROADS'|'CRSCNT'|'CRSE'|'CRSENT'|'CRSNT'|'CRSSING'|'CRSSNG'|'CRT'|'CSWY'|'CT'|'CTR'|'CTS'|'CURVE'|'CV'|'CYN'|'DALE'|'DAM'|'DIV'|'DIVIDE'|'DL'|'DM'|'DR'|'DRIV'|'DRIVE'|'DRIVES'|'DRV'|'DV'|'DVD'|'EST'|'ESTATE'|'ESTATES'|'ESTS'|'EXP'|'EXPR'|'EXPRESS'|'EXPW'|'EXPY'|'EXT'|'EXTENSION'|'EXTENSIONS'|'EXTN'|'EXTNSN'|'EXTS'|'FALL'|'FALLS'|'FERRY'|'FIELD'|'FIELDS'|'FLAT'|'FLATS'|'FLD'|'FLDS'|'FLS'|'FLT'|'FLTS'|'FORD'|'FORDS'|'FOREST'|'FORESTS'|'FORG'|'FORGE'|'FORGES'|'FORK'|'FORKS'|'FORT'|'FRD'|'FREEWAY'|'FREEWY'|'FRG'|'FRK'|'FRKS'|'FRRY'|'FRST'|'FRT'|'FRWAY'|'FRWY'|'FRY'|'FT'|'FWY'|'GARDEN'|'GARDENS'|'GARDN'|'GATEWAY'|'GATEWY'|'GATWAY'|'GDN'|'GDNS'|'GLEN'|'GLENS'|'GLN'|'GRDEN'|'GRDN'|'GRDNS'|'GREEN'|'GREENS'|'GRN'|'GROV'|'GROVE'|'GROVES'|'GRV'|'GTWAY'|'GTWY'|'HARB'|'HARBOR'|'HARBORS'|'HARBR'|'HAVEN'|'HAVN'|'HBR'|'HEIGHT'|'HEIGHTS'|'HGTS'|'HIGHWY'|'HILL'|'HILLS'|'HL'|'HLLW'|'HLS'|'HOLLOW'|'HOLLOWS'|'HOLW'|'HOLWS'|'HRBOR'|'HT'|'HTS'|'HVN'|'HWAY'|'HWY'|'INLET'|'INLT'|'IS'|'ISLAND'|'ISLANDS'|'ISLE'|'ISLES'|'ISLND'|'ISLNDS'|'ISS'|'JCT'|'JCTION'|'JCTN'|'JCTNS'|'JCTS'|'JUNCTION'|'JUNCTIONS'|'JUNCTN'|'JUNCTON'|'KEY'|'KEYS'|'KNL'|'KNLS'|'KNOL'|'KNOLL'|'KNOLLS'|'KY'|'KYS'|'LA'|'LAKE'|'LAKES'|'LAND'|'LANDING'|'LANE'|'LANES'|'LCK'|'LCKS'|'LDG'|'LDGE'|'LF'|'LGT'|'LIGHT'|'LIGHTS'|'LK'|'LKS'|'LN'|'LNDG'|'LNDNG'|'LOAF'|'LOCK'|'LOCKS'|'LODG'|'LODGE'|'LOOPS'|'MALL'|'MANOR'|'MANORS'|'MDW'|'MDWS'|'MEADOW'|'MEADOWS'|'MEDOWS'|'MEWS'|'MILL'|'MILLS'|'MISSION'|'MISSN'|'ML'|'MLS'|'MNR'|'MNRS'|'MNT'|'MNTAIN'|'MNTN'|'MNTNS'|'MOTORWAY'|'MOUNT'|'MOUNTAIN'|'MOUNTAINS'|'MOUNTIN'|'MSN'|'MSSN'|'MT'|'MTIN'|'MTN'|'NCK'|'NECK'|'ORCH'|'ORCHARD'|'ORCHRD'|'OVAL'|'OVERPASS'|'OVL'|'PARK'|'PARKS'|'PARKWAY'|'PARKWAYS'|'PARKWY'|'PASS'|'PASSAGE'|'PATH'|'PATHS'|'PIKE'|'PIKES'|'PINE'|'PINES'|'PK'|'PKWAY'|'PKWY'|'PKWYS'|'PKY'|'PL'|'PLACE'|'PLAIN'|'PLAINES'|'PLAINS'|'PLAZA'|'PLN'|'PLNS'|'PLZ'|'PLZA'|'PNES'|'POINT'|'POINTS'|'PORT'|'PORTS'|'PR'|'PRAIRIE'|'PRARIE'|'PRK'|'PRR'|'PRT'|'PRTS'|'PT'|'PTS'|'RAD'|'RADIAL'|'RADIEL'|'RADL'|'RAMP'|'RANCH'|'RANCHES'|'RAPID'|'RAPIDS'|'RDG'|'RDGE'|'RDGS'|'RDS'|'REST'|'RIDGE'|'RIDGES'|'RIV'|'RIVER'|'RIVR'|'RNCH'|'RNCHS'|'ROAD'|'ROADS'|'ROUTE'|'ROW'|'RPD'|'RPDS'|'RST'|'RUE'|'RUN'|'RVR'|'SHL'|'SHLS'|'SHOAL'|'SHOALS'|'SHOAR'|'SHOARS'|'SHORE'|'SHORES'|'SHR'|'SHRS'|'SKYWAY'|'SMT'|'SPG'|'SPGS'|'SPNG'|'SPNGS'|'SPRING'|'SPRINGS'|'SPRNG'|'SPRNGS'|'SPUR'|'SPURS'|'SQ'|'SQR'|'SQRE'|'SQRS'|'SQU'|'SQUARE'|'SQUARES'|'ST'|'STA'|'STATION'|'STATN'|'STN'|'STR'|'STRA'|'STRAV'|'STRAVE'|'STRAVEN'|'STRAVENUE'|'STRAVN'|'STREAM'|'STREET'|'STREETS'|'STREME'|'STRM'|'STRT'|'STRVN'|'STRVNUE'|'SUMIT'|'SUMITT'|'SUMMIT'|'TER'|'TERR'|'TERRACE'|'THROUGHWAY'|'TPK'|'TPKE'|'TR'|'TRACE'|'TRACES'|'TRACK'|'TRACKS'|'TRAFFICWAY'|'TRAIL'|'TRAILS'|'TRAK'|'TRCE'|'TRFY'|'TRK'|'TRKS'|'TRL'|'TRLRS'|'TRLS'|'TRNPK'|'TRPK'|'TUNEL'|'TUNL'|'TUNLS'|'TUNNEL'|'TUNNELS'|'TUNNL'|'TURNPIKE'|'TURNPK'|'UN'|'UNDERPASS'|'UNION'|'UNIONS'|'VALLEY'|'VALLEYS'|'VALLY'|'VDCT'|'VIA'|'VIADCT'|'VIADUCT'|'VIEW'|'VIEWS'|'VILL'|'VILLAG'|'VILLAGE'|'VILLAGES'|'VILLE'|'VILLG'|'VILLIAGE'|'VIS'|'VIST'|'VISTA'|'VL'|'VLG'|'VLGS'|'VLLY'|'VLY'|'VLYS'|'VST'|'VSTA'|'VW'|'VWS'|'WALK'|'WALKS'|'WALL'|'WAY'|'WAYS'|'WELL'|'WELLS'|'WLS'|'WY'|'XING'
);
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
/* 5,266 confirmed cases. Not in 28.F, but should be! */
CommonUSRoute 
	:	('US' SPACE 'ROUTE' | 'US' SPACE 'RTE')
	;
		
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
/* Those commented out have no addresses in the wild from our CASS */
StandardSecondaryAddressType: ('APARTMENT'|'APT'|'BUILDING'|'BLDG'|'DEPARTMENT'|'DEPT'|'FLOOR'|'FL'|'HANGER'|'HNGR'|'KEY'|'LOT'|'PIER'|'ROOM'|'RM'|'SLIP'|'SPACE'|'SPC'|'STOP'|'SUITE'|'STE'|'TRAILER'|'TRLR'|'UNIT');
ExtendedSecondaryAddressType : ('BASEMENT'|'BSMT'|'FRONT'|'FRNT'|'LOBBY'|'LBBY'|'LOWER'|'LOWR'|'OFFICE'|'OFC'|'PENTHOUSE'|'PH'|'REAR'|'SIDE'|'UPPER'|'UPPR');


//this syn predicate gets rid of some ambigutity for street number cases like S123, so it won't match here


AbbreviatedDirectional 
	:	 //{ahead_pt('N ')||ahead_pt('S ')||ahead_pt('E ')||ahead_pt('W ')||ahead_pt('NW ')||ahead_pt('NE ')||ahead_pt('SW ')||ahead_pt('SE ')}
				//=>
				 ('N'|'S'|'E'|'W'|'NW'|'NE'|'SW'|'SE')
	;
Directional 
	:	 ('NORTH'|'SOUTH'|'EAST'|'WEST'|'NORTHWEST'|'NORTHEAST'|'SOUTHWEST'|'SOUTHEAST')
	;
SpacedDirectional
	: 	{ahead_pt("NORTH WEST")||ahead_pt("NORTH EAST")||ahead_pt("SOUTH WEST")||ahead_pt("SOUTH EAST")}?
			=> ('NORTH' SPACE 'WEST'|'NORTH' SPACE 'EAST'|'SOUTH' SPACE 'WEST'|'SOUTH' SPACE 'EAST');

/* Domain sourced from TIGER Technical Documentation 2013 (Appendix E) */
PreModifier
	:	 ('ACC'|'ALT'|'BUS'|'BYP'|'CON'|'EXD'|'EXN'|'HST'|'LP'|'OLD'|'PVT'|'PUB'|'SCN'|'SPR'|'RMP'|'UNP'|'OVP'|'ACCESS'|'ALTERNATE'|'BUSINESS'|'BYPASS'|'CONNECTOR'|'EXTENDED'|'EXTENSION'|'HISTORIC'|'LOOP'|'PRIVATE'|'PUBLIC'|'SCENIC'|'SPUR'|'RAMP'|'UNDERPASS'|'OVERPASS')
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
                      | addressNumberPrefix (SPACE)? addressNumber ((SPACE)? addressNumberSuffix| concatenatedAddressNumberSuffix)? 
                      	-> ^(COMPLETE_ADDRESS_NUMBER addressNumberPrefix addressNumber (SPACE)? (addressNumberSuffix)? (concatenatedAddressNumberSuffix)?) 
		      ;
//Numeric only per FGDC
addressNumber : Numbers 
		-> ^(ADDRESS_NUMBER Numbers)
	      ;
//Only USPS Profile Supported 28 Sec. D1, D3
addressNumberPrefix  : AbbreviatedDirectional
			-> ^(ADDRESS_NUMBER_PREFIX AbbreviatedDirectional)
		     |  Letters //(lettersOrNumbers)?
			-> ^(ADDRESS_NUMBER_PREFIX Letters /*(lettersOrNumbers)?*/)
                     | addressNumber seperator addressNumber //Only Valid if SPACE Exists
                     	-> ^(ADDRESS_NUMBER_PREFIX addressNumber seperator addressNumber)
       		     ;            
                         
//Only USPS Profile Supported 28 Sec. D4
addressNumberSuffix : Numbers '/' Numbers    
			-> ^(ADDRESS_NUMBER_SUFFIX Numbers '/' Numbers)                                  
		    ;
concatenatedAddressNumberSuffix : AbbreviatedDirectional
					-> ^(ADDRESS_NUMBER_SUFFIX  AbbreviatedDirectional)                                
				| Letters (lettersOrNumbers)? 
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

completeStreetName :((streetNamePreDirectional SPACE)?  streetNamePreType SPACE ((streetName|specialStreetName) streetNamePostModifier) (SPACE streetNamePostDirectional)?)
             		=> (streetNamePreDirectional SPACE)? streetNamePreType SPACE ((streetName|specialStreetName) streetNamePostModifier) (SPACE streetNamePostDirectional)?
                  		-> ^(COMPLETE_STREET_NAME (streetNamePreDirectional)?  streetNamePreType ^(STREET_NAME (streetName)? (specialStreetName)?) (streetNamePostModifier)? (streetNamePostDirectional)?)
                   | (streetNamePreModifier SPACE)? (streetNamePreDirectional SPACE)? streetNamePreType SPACE lettersOrNumbers (SPACE streetNamePostDirectional)?
	                   -> ^(COMPLETE_STREET_NAME (streetNamePreModifier)? (streetNamePreDirectional)?  streetNamePreType ^(STREET_NAME (lettersOrNumbers)?) (streetNamePostDirectional)?)
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
streetName : addressLettersOrNumbers SPACE (streetName | specialStreetName)?
           ;       
//to handle an issue with Suffix reductions
restrictedStreetName : addressLettersOrNumbers SPACE (restrictedStreetName | restrictedSpecialStreetName)?
           ;       

specialStreetName  : highway SPACE (streetName|specialStreetName)?       		   
		   | directional SPACE (streetName|specialStreetName)?
		   | secondaryAddressIdentifier SPACE (streetName|specialStreetName)? 
                   | suffix SPACE (restrictedStreetName|restrictedSpecialStreetName)?   
                   | PreModifier SPACE (streetName|specialStreetName)? 
//handle N FRONT ST, LOWER VALLEY PIKE, etc.                  
                   ;
                   

//to handle an issue with Suffix reductions
restrictedSpecialStreetName  
		   : highway SPACE (restrictedStreetName|restrictedSpecialStreetName)?       		   
		   | directional SPACE (restrictedStreetName|restrictedSpecialStreetName)?
                   | suffix SPACE (restrictedStreetName|restrictedSpecialStreetName)?   
                   | PreModifier SPACE (restrictedStreetName|restrictedSpecialStreetName)? 
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
        | CommonUSRoute
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

secondaryAddressIdentifier 
	:	StandardSecondaryAddressType
	|	ExtendedSecondaryAddressType 
	;
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
abbreviatedSubaddressType : StandardSecondaryAddressType SPACE subaddressIdentifier
				-> ^(SUBADDRESS_TYPE StandardSecondaryAddressType) ^(SUBADDRESS_IDENTIFIER subaddressIdentifier)?
                          | ExtendedSecondaryAddressType
	                        -> ^(SUBADDRESS_TYPE ExtendedSecondaryAddressType)
                          | ExtendedSecondaryAddressType SPACE subaddressIdentifier
	                        -> ^(SUBADDRESS_TYPE ExtendedSecondaryAddressType) ^(SUBADDRESS_IDENTIFIER subaddressIdentifier)
			  ;
//street name gives us most flexibility here, may want to make seperate productions if we want special logic.			 
subaddressIdentifier : /*(addressLettersOrNumbers | directional) (subaddressIdentifier)?
				=> */(addressLettersOrNumbers | directional) (directional)?			
		     ;
 
