
INSERT INTO public."CalculTarif" VALUES (1, 'Menuiserie', 'porte', '2018-03-09 10:43:11.443283+00', NULL);

INSERT INTO public."VariableCalculTarif" VALUES (1, 'quantity', 'numeric', '2018-03-09 10:45:48.89088+00', NULL);
INSERT INTO public."VariableCalculTarif" VALUES (1, 'isAlu', 'boolean', '2018-03-09 10:45:48.89088+00', NULL);
INSERT INTO public."VariableCalculTarif" VALUES (1, 'isPVC', 'boolean', '2018-03-09 10:45:48.89088+00', NULL);
INSERT INTO public."VariableCalculTarif" VALUES (1, 'isOscillo', 'boolean', '2018-03-09 10:45:48.89088+00', NULL);
INSERT INTO public."VariableCalculTarif" VALUES (1, 'isBattante', 'boolean', '2018-03-09 10:45:48.89088+00', NULL);

INSERT INTO public."AjoutProduit" VALUES (4, 1, 'quantity', 'azerty', '2018-03-09 10:45:59.369308+00', NULL);

INSERT INTO public."AjoutProduitCaracteristique" VALUES (2, 4, 'TypeMateriau', 'Alu', '2018-03-09 10:48:29.90059+00', NULL);
INSERT INTO public."AjoutProduitCaracteristique" VALUES (3, 4, 'TypeMateriau', 'PVC', '2018-03-09 10:48:29.90059+00', NULL);
INSERT INTO public."AjoutProduitCaracteristique" VALUES (4, 4, 'TypeOuverture', 'OscilloBattante', '2018-03-09 10:48:29.90059+00', NULL);
INSERT INTO public."AjoutProduitCaracteristique" VALUES (5, 4, 'TypeOuverture', 'Battante', '2018-03-09 10:48:29.90059+00', NULL);


INSERT INTO public."ConditionOperator" VALUES ('GreaterThan', '{numeric}');
INSERT INTO public."ConditionOperator" VALUES ('LesserThan', '{numeric}');
INSERT INTO public."ConditionOperator" VALUES ('Equals', '{numeric,boolean}');

INSERT INTO public."ConditionAjoutProduit" VALUES (2, 4, 'quantity', 'GreaterThan', '0', '2018-03-09 14:10:36.807138+00', NULL);

INSERT INTO public."ConditionAjoutProduitCaracteristique" VALUES (1, 2, 'isAlu', 'Equals', 'true', '2018-03-09 10:49:51.407341+00', '2018-03-09 10:49:51.407341+00');
INSERT INTO public."ConditionAjoutProduitCaracteristique" VALUES (2, 3, 'isPVC', 'Equals', 'true', '2018-03-09 10:49:51.407341+00', '2018-03-09 10:49:51.407341+00');
INSERT INTO public."ConditionAjoutProduitCaracteristique" VALUES (3, 4, 'isOscillo', 'Equals', 'true', '2018-03-09 10:49:51.407341+00', '2018-03-09 10:49:51.407341+00');
INSERT INTO public."ConditionAjoutProduitCaracteristique" VALUES (4, 5, 'isBattante', 'Equals', 'true', '2018-03-09 10:49:51.407341+00', '2018-03-09 10:49:51.407341+00');

SELECT pg_catalog.setval('public."AjoutProduitCaracteristique_idAjoutProduitCaracteristique_seq"', 5, true);

SELECT pg_catalog.setval('public."AjoutProduit_idAjoutProduit_seq"', 4, true);

SELECT pg_catalog.setval('public."CalculTarif_idCalculTarif_seq"', 1, true);

SELECT pg_catalog.setval('public."ConditionAjoutProduitCaracter_idConditionAjoutProduitCaract_seq"', 4, true);

SELECT pg_catalog.setval('public."ConditionAjoutProduit_idConditionAjoutProduit_seq"', 2, true);
