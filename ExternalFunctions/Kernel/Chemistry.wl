AcentricFactor[cas_String] := LoadExternalFunction["Python", "chemicals.acentric.omega"][cas];
AcentricFactor[ei_ExternalIdentifier] := LoadExternalFunction["Python", "chemicals.acentric.omega"][ei["ExternalID"]];
AcentricFactor[e_Entity] := LoadExternalFunction["Python", "chemicals.acentric.omega"][First[e[EntityProperty["Chemical","CASRegistryNumber"]]]["ExternalID"]];

StielPolarFactor[psat_, pc_, omega_ ] := LoadExternalFunction["Python", "chemicals.acentric.Stiel_polar_factor"][psat,pc,omega];
StielPolarFactor[psat_Quantity, pc_Quantity, omega_ ] := LoadExternalFunction["Python", "chemicals.acentric.Stiel_polar_factor"][QuantityMagnitude[UnitConvert[psat,"Pascals"]],QuantityMagnitude[UnitConvert[pc,"Pascals"]],omega];

LeeKeslerOmega[Tb_, Tc_, Pc_] := LoadExternalFunction["Python", "chemicals.acentric.LK_omega"][Tb,Tc,Pc];
LeeKeslerOmega[Tb_Quantity, Tc_Quantity, Pc_Quantity] := LoadExternalFunction["Python", "chemicals.acentric.LK_omega"][QuantityMagnitude[UnitConvert[Tb,"Kelvins"]],QuantityMagnitude[UnitConvert[Tc,"Kelvins"]],QuantityMagnitude[UnitConvert[Pc,"Pascals"]]];
