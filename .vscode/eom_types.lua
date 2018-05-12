
--# assume global class EOM_PANEL
--# assume global class EOM_BUTTON


--# assume global class EOM_MODEL

--# assume global class EOM_ELECTOR
--# assume global class EOM_CULT
--# assume global class EOM_ACTION
--# assume global class EOM_CIVIL_WAR
--# assume global class EOM_TRAIT


--the entity class is used to reflect functions which can take either an elector count or a religion cult. This reduces work.
--Any methods valid for both classes should be reflected below.


--# assume global class EOM_ENTITY
--# assume EOM_ENTITY.change_loyalty: method(i: number)