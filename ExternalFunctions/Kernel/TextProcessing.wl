UnicodeName[s_String /; StringLength[s]===1 ] := LoadExternalFunction["Python", "unicodedata.name"][s]
UnicodeLookup[s_String] := LoadExternalFunction["Python", "unicodedata.lookup"][s]