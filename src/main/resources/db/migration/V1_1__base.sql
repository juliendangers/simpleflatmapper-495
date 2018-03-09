CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

----------------
--   TABLES   --
----------------

CREATE TYPE VARIABLETYPE AS ENUM ('numeric', 'boolean');

CREATE TABLE "CalculTarif" (
  "idCalculTarif" SERIAL PRIMARY KEY,
  "nom" TEXT NOT NULL,
  "action" TEXT NOT NULL,
  "dateCreation" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  "dateMiseAJour" TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "VariableCalculTarif" (
  "idCalculTarif" INTEGER NOT NULL,
  "variableName" TEXT NOT NULL,
  "variableType" VARIABLETYPE NOT NULL,
  "dateCreation" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  "dateMiseAJour" TIMESTAMP WITH TIME ZONE,
   PRIMARY KEY ("idCalculTarif", "variableName")
);

ALTER TABLE "VariableCalculTarif"
  ADD CONSTRAINT "fk_variablecalcultarif_idcalcultarif"
FOREIGN KEY ("idCalculTarif")
REFERENCES "CalculTarif" ("idCalculTarif");

CREATE TABLE "ConditionOperator" (
  "idConditionOperator" TEXT PRIMARY KEY,
  "supportedTypes" VARIABLETYPE[] NOT NULL
);

CREATE TABLE "AjoutProduit" (
  "idAjoutProduit" SERIAL PRIMARY KEY,
  "idCalculTarif" INTEGER NOT NULL,
  "variableQuantite" TEXT,
  "idProduit" TEXT NOT NULL,
  "dateCreation" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  "dateMiseAJour" TIMESTAMP WITH TIME ZONE
);

ALTER TABLE "AjoutProduit"
  ADD CONSTRAINT "fk_ajoutproduit_idcalcultarif"
FOREIGN KEY ("idCalculTarif")
REFERENCES "CalculTarif" ("idCalculTarif");

CREATE TABLE "ConditionAjoutProduit" (
  "idConditionAjoutProduit" SERIAL PRIMARY KEY,
  "idAjoutProduit" INTEGER NOT NULL,
  "variableName" TEXT NOT NULL,
  "idConditionOperator" TEXT NOT NULL,
  "valueCondition" TEXT NOT NULL,
  "dateCreation" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  "dateMiseAJour" TIMESTAMP WITH TIME ZONE
);

ALTER TABLE "ConditionAjoutProduit"
  ADD CONSTRAINT "fk_conditionajoutproduit_idajoutproduit"
FOREIGN KEY ("idAjoutProduit")
REFERENCES "AjoutProduit" ("idAjoutProduit");

ALTER TABLE "ConditionAjoutProduit"
  ADD CONSTRAINT "fk_conditionajoutproduit_idconditionoperator"
FOREIGN KEY ("idConditionOperator")
REFERENCES "ConditionOperator" ("idConditionOperator");

CREATE TABLE "AjoutProduitCaracteristique" (
  "idAjoutProduitCaracteristique" SERIAL PRIMARY KEY,
  "idAjoutProduit" INTEGER NOT NULL,
  "idCaracteristique" TEXT NOT NULL,
  "valueCaracteristique" TEXT NOT NULL,
  "dateCreation" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  "dateMiseAJour" TIMESTAMP WITH TIME ZONE
);

ALTER TABLE "AjoutProduitCaracteristique"
  ADD CONSTRAINT "fk_ajoutproduitcaracteristique_idajoutproduit"
FOREIGN KEY ("idAjoutProduit")
REFERENCES "AjoutProduit" ("idAjoutProduit");

CREATE TABLE "ConditionAjoutProduitCaracteristique" (
  "idConditionAjoutProduitCaracteristique" SERIAL PRIMARY KEY,
  "idAjoutProduitCaracteristique" INTEGER NOT NULL,
  "variableName" TEXT NOT NULL,
  "idConditionOperator" TEXT NOT NULL,
  "valueCondition" TEXT NOT NULL,
  "dateCreation" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  "dateMiseAJour" TIMESTAMP WITH TIME ZONE
);

ALTER TABLE "ConditionAjoutProduitCaracteristique"
  ADD CONSTRAINT "fk_conditionajoutproduitcaracteristique_idajoutproduitcaracteristique"
FOREIGN KEY ("idAjoutProduitCaracteristique")
REFERENCES "AjoutProduitCaracteristique" ("idAjoutProduitCaracteristique");

ALTER TABLE "ConditionAjoutProduitCaracteristique"
  ADD CONSTRAINT "fk_conditionajoutproduitcaracteristique_idconditionoperator"
FOREIGN KEY ("idConditionOperator")
REFERENCES "ConditionOperator" ("idConditionOperator");

-------------------
--   FUNCTIONS   --
-------------------

CREATE OR REPLACE FUNCTION set_date_maj()
  RETURNS TRIGGER AS
$func$
BEGIN
  NEW."dateMiseAJour" := now() AT TIME ZONE 'utc';
  RETURN NEW;
END
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_variable_condition_produit()
  RETURNS TRIGGER AS
$func$
DECLARE
  variableIsValid boolean;
BEGIN
  SELECT true INTO variableIsValid FROM "CalculTarif"
    JOIN "AjoutProduit" USING ("idCalculTarif")
    JOIN "VariableCalculTarif" USING ("idCalculTarif")
    JOIN "ConditionOperator" ON "idConditionOperator" = NEW."idConditionOperator"
  WHERE "variableType" = ANY("supportedTypes") AND
        "variableName" = NEW."variableName" AND
        "AjoutProduit"."idAjoutProduit" = NEW."idAjoutProduit";
  IF variableIsValid IS NOT TRUE THEN
    RAISE EXCEPTION 'Variable % invalide', NEW."variableName";
  END IF;

  RETURN NEW;
END
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_variable_condition_caracteristique_produit()
  RETURNS TRIGGER AS
$func$
DECLARE
  variableIsValid boolean;
BEGIN
  SELECT true INTO variableIsValid FROM "CalculTarif"
    JOIN "AjoutProduit" USING ("idCalculTarif")
    JOIN "AjoutProduitCaracteristique" USING ("idAjoutProduit")
    JOIN "VariableCalculTarif" v USING ("idCalculTarif")
    JOIN "ConditionOperator" ON "idConditionOperator" = NEW."idConditionOperator"
  WHERE "variableType" = ANY("supportedTypes") AND
        "variableName" = NEW."variableName" AND
        "AjoutProduitCaracteristique"."idAjoutProduitCaracteristique" = NEW."idAjoutProduitCaracteristique";
  IF variableIsValid IS NOT TRUE THEN
    RAISE EXCEPTION 'Variable % invalide', NEW."variableName";
  END IF;

  RETURN NEW;
END
$func$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_variablequantite_type_ajout_produit()
  RETURNS TRIGGER AS
$func$
DECLARE
  variableIsValid boolean;
BEGIN
  SELECT true INTO variableIsValid FROM "CalculTarif" c
    JOIN "VariableCalculTarif" v USING ("idCalculTarif")
  WHERE v."variableType" = 'numeric' AND
        v."variableName" = NEW."variableQuantite" AND
        c."idCalculTarif" = NEW."idCalculTarif";
  IF variableIsValid IS NOT TRUE THEN
    RAISE EXCEPTION 'Variable quantité % invalide', NEW."variableQuantite";
  END IF;

  RETURN NEW;
END
$func$ LANGUAGE plpgsql;
------------------
--   TRIGGERS   --
------------------

CREATE TRIGGER tr_calcultarif_update_datemaj
  BEFORE UPDATE ON "CalculTarif"
  FOR EACH ROW EXECUTE PROCEDURE set_date_maj();

CREATE TRIGGER tr_variablecalcultarif_update_datemaj
  BEFORE UPDATE ON "VariableCalculTarif"
  FOR EACH ROW EXECUTE PROCEDURE set_date_maj();

CREATE TRIGGER tr_ajoutproduit_update_datemaj
  BEFORE UPDATE ON "AjoutProduit"
  FOR EACH ROW EXECUTE PROCEDURE set_date_maj();

CREATE TRIGGER tr_conditionajoutproduit_update_datemaj
  BEFORE UPDATE ON "ConditionAjoutProduit"
  FOR EACH ROW EXECUTE PROCEDURE set_date_maj();

CREATE TRIGGER tr_ajoutproduitcaracteristique_update_datemaj
  BEFORE UPDATE ON "AjoutProduitCaracteristique"
  FOR EACH ROW EXECUTE PROCEDURE set_date_maj();

CREATE TRIGGER tr_conditionajoutproduitcaracteristique_update_datemaj
  BEFORE INSERT OR UPDATE ON "ConditionAjoutProduitCaracteristique"
  FOR EACH ROW EXECUTE PROCEDURE set_date_maj();

CREATE TRIGGER tr_conditionajoutproduit_upsert_variable
  BEFORE INSERT OR UPDATE ON "ConditionAjoutProduit"
  FOR EACH ROW EXECUTE PROCEDURE check_variable_condition_produit();

CREATE TRIGGER tr_conditionajoutproduitcaracteristique_upsert_variable
  BEFORE INSERT OR UPDATE ON "ConditionAjoutProduitCaracteristique"
  FOR EACH ROW EXECUTE PROCEDURE check_variable_condition_caracteristique_produit();

CREATE TRIGGER tr_ajoutproduit_upsert_variablequantite
  BEFORE INSERT OR UPDATE ON "AjoutProduit"
  FOR EACH ROW EXECUTE PROCEDURE check_variablequantite_type_ajout_produit();
