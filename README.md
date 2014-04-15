Do you have addresses where all the elements are in a single field?

    129 1/2 E HARTVILLE CIR W APT 3
    [_____________________________]
                   |
                   \ Address

But would like your addresses to look more like this?

    A129 1/2 E HARTVILLE CIR W APT 3
    |[ ] [ ] | [       ] [ ] | [ ] |
    | |   |  |     |      |  |  |  \ Subaddress Identifier
    | |   |  |     |      |  |  \ Subaddress Type
    | |   |  |     |      |  \ Street Name Post Directional
    | |   |  |     |      \ Street Name Post Type
    | |   |  |     \ Street Name
    | |   |  \ Street Name Pre Directional
    | |   \ Address Number Suffix
    | \ Address Number
    \ Address Number Prefix


Hi3 can help. Hi3 is an address parser that uses the popular parser generator ANTLRv3.  

**What Hi3 Can Do**

- Hi3 will parse addresses into elements defined by a subset of the [United States Thoroughfare, Landmark, and Postal Address Data Standard (FGDC-STD-016-2011)](https://www.fgdc.gov/standards/projects/FGDC-standards-projects/street-address/index_html) produced by the [Federal Geographic Data Committee](https://www.fgdc.gov/).
- Hi3 will parse most addresses found in the United States.

**What Hi3 Can't Do**

- Hi3 is not an address sanitizer. That is, the parser assumes the input is already well formed. 
- Hi3 is not an address validator. It cannot tell you if the address is deliverable, or even if it exists.
- Hi3 is not an address standardizer. It will recognize common abbreviations, but will not convert them to their canonical form. 
- Hi3 is designed to parse mailable addresses. Usage for other purposes has not been validated.

**About this Documentation**

This documentation is designed to show conformance / non-conformance with the FGDC standard referenced above. Please refer to the standard for further information on the elements.

## COMMON DEVIATIONS FROM STANDARD ##

- Abbreviations are recognized for any element type
- Element separators cannot be user defined
- For any address, a Street Name Pre Type or Street Name Post Type is always required.

## COMPLETE ADDRESS NUMBER ##
Full concatenation of constituent elements per FDGC-STD-016-2011

      Q129 1/2
      | |   \ Address Number Suffix
      |  \ Address Number
      \ Address Number Prefix
### Address Number Prefix ###

####Single Hyphenated Address Number Prefixed####
Supported Example

    194-5 129 1/2
    224-6  |   \ Address Number Suffix
      |     \ Address Number
      \ Address Number Prefix
####Alpha Address Number Prefix####
Supported example

     A 129 1/2
    ABC |   \ Address Number Suffix
     |   \ Address Number
      \ Address Number Prefix
####Alpha Numeric Address Number Prefixed####
The following is not currently supported

    N6W2 129 1/2
    |    |    \ Address Number Suffix
    |     \ Address Number
     \ Address Number Prefix
####Address Number Prefix and Address Number separated by a hyphen####
The following is not supported as it creates ambiguity in the parser

    100-129 1/2
    [  ][ ] [ ]
     |   |   \ Address Number Suffix
     |    \ Address Number
      \ Address Number Prefix
####Address Number####
Supported

###Address Number Suffix###
####Fractional Address Number Suffix####
Supported example

    194-5 129 1/2
    199-5 144-1/2 (dash is discarded)
     |  |    \- Address Number Suffix
     |   \- Address Number
      \- Address Number Prefix
####Alphanumeric (must begin with alpha) string concatenated to Address Number####
Supported example

    194-5 129A
    224-A  | \ Address Number Suffix
    AAB-3   \ Address Number
      \ Address Number Prefix
####(must begin with alpha) string concatenated to Address Number, but separated with dash####
The following is currently not supported

    194-5 129-AQ
    224-A  |  \ Address Number Suffix
    AAB-3   \ Address Number
      \ Address Number Prefix
####Address Number Prefix and Address Number separated by a hyphen####
The following is not supported as it creates ambiguity in the parser

    194-5 129-44
    224-A  |  \ Address Number Suffix
    AAB-3   \ Address Number
     \ Address Number Prefix
####Address Number Prefix and Address Number separated by a period####
The following is currently not supported

    194-5 129.90
    224-A  |  \ Address Number Suffix
    AAB-3   \ Address Number
     \ Address Number Prefix

##COMPLETE STREET NAME##
Full concatenation of constituent elements per FDGC-STD-016-2011

    129 OLD W STATE ROUTE 8 AVE N EXT STE 3
    [ ] [                           ] [ ] |
     |             |                   |   \ Subaddress Identifier
     |             |                    \ Subaddress Type
     |              \ Complete Street Name                
      \  Street Number

###Street Name Pre Modifier###
   
####Street Name Pre Modifier followed by Street Name Pre Type####
Supported example

    129 OLD W STATE ROUTE 8 
    [_] ALT | [_________] |     
     |   |  |      |       \ Street Name
     |   |  |       \ Street Name Pre Type
     |   |   \ Street Name Pre Directional  
     |    \ Street Name Pre Modifier
      \ Street Number

####Notes####

In many cases local knowledge is required to determine when a Street Name Pre Modifier ends and a Street Name begins. Thus, implementers are free to add custom tokens to enhance the parser for their purposes.

###Street Name Pre Type###
####Street Name Pre Type followed by a numeric street name####
Supported example

    129 OLD N STATE ROUTE 8
    [_] [_] |   HIGHWAY   3
     |   |  | [_________] |  
     |   |  |      |       \ Street Name
     |   |  |       \ Street Name Pre Type
     |   |   \ Street Name Pre Directional  
     |    \ Street Name Pre Modifier
      \ Street Number
####Street Name Pre Type followed by an alphanumeric Street Name####
The following is not currently supported

    129 OLD N STATE ROUTE AA
    [_] [_] |   HIGHWAY   Z4
     |   |  | [_________] |  
     |   |  |      |      | 
     |   |  |      |       \ Street Name
     |   |  |       \ Street Name Pre Type
     |   |   \ Street Name Pre Directional  
     |    \ Street Name Pre Modifier
      \ Street Number
####Street Name Pre Type and Street Name separated by prepositional phrase####
The following is not currently supported

    129 OLD N AVENUE OF THE AMERICAS
    [_] [_] | [____] [____] [______]  
     |   |  |    |     |       |  
     |   |  |    |     |        \ Street Name  
     |   |  |    |      \ Separator (Not Implemented)      
     |   |  |     \ Street Name Pre Type
     |   |  \ Street Name Pre Directional  
     |   \ Street Name Pre Modifier
      \ Street Number
####Multiple Street Name Pre Types in a single address####
The following is not currently supported

    129 OLD N BYPASS HIGHWAY 261
    [_] [_] | [____________]  |       
     |   |  |      |           \ Street Name
     |   |  |       \ Street Name Pre Type
     |   |   \ Street Name Pre Directional  
     |    \ Street Name Pre Modifier
      \ Street Number

####Notes####

FDGC-STD-016-2011 explicitly disallows abbreviations. Hi3 allows abbreviated Street Name Pre Types.

###Street Name###
Partial implementation of FDGC-STD-016-2011. A freeform group of Numbers, Letters, Spaces and Dashes are allowed. Apostrophes are not and would be a nontrivial addition.

###Street Name Post Type###
####Multiple Street Name Post Types in a single address####
When a street name has a two suffixes listed in succession, the first becomes part of the Street Name, the second becomes the Street Name Post Type (FDGC Note 4). 

    489 9TH AVE BYPASS
    [_] [_____] [____]
     |    |       |
     |    |        \ Street Name Post Type
     |     \ Street Name   
      \ Street Number

###Street Name Post Directional###

Full implementation of FDGC-STD-016-2011, with the caveat that the standard explicitly disallows abbreviations. Hi3 allows abbreviated directional. Local knowledge may be required to determine if an apparent Street Name Pre Directional is actually part of the Street Name.

###Street Name Post Modifier###
Not Implemented

##COMPLETE SUBADDRESS##
Complete implementation

###Subaddress Type###
Complete implementation

###Subaddress Identifier###
Complete, with the same limitations as Street Name.
