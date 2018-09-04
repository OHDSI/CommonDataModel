The RELATIONSHIP table provides a reference list of all types of relationships that can be used to associate any two concepts in the CONCEPT_RELATIONSHP table. 

Field|Required|Type|Description
:-----------------------|:--------|:------------|:-----------------------------------------
|relationship_id|Yes|varchar(20)| The type of relationship captured by the relationship record.|
|relationship_name|Yes|varchar(255)| The text that describes the relationship type.|
|is_hierarchical|Yes|varchar(1)|Defines whether a relationship defines concepts into classes or hierarchies. Values are 1 for hierarchical relationship or 0 if not.|
|defines_ancestry|Yes|varchar(1)|Defines whether a hierarchical relationship contributes to the concept_ancestor table. These are subsets of the hierarchical relationships. Valid values are 1 or 0.|
|reverse_relationship_id|Yes|varchar(20)|The identifier for the relationship used to define the reverse relationship between two concepts.|
|relationship_concept_id|Yes|integer|A foreign key that refers to an identifier in the CONCEPT table for the unique relationship concept.|

### Conventions

  * There is one record for each Relationship.
  * Relationships are classified as hierarchical (parent-child) or non-hierarchical (lateral)
  * They are used to determine which concept relationship records should be included in the computation of the CONCEPT_ANCESTOR table.
  * The relationship_id field contains an alphanumerical identifier, that can also be used as the abbreviation of the Relationship.
  * The relationship_name field contains the unabbreviated names of the Relationship.
  * Relationships all exist symmetrically, i.e. in both direction. The relationship_id of the opposite Relationship is provided in the reverse_relationship_id field.
  * Each Relationship also has an equivalent entry in the Concept table, which is recorded in the relationship_concept_id field. This is for purposes of creating a closed Information Model, where all entities in the OMOP CDM are covered by unique Concepts.
  * Hierarchical Relationships are used to build a hierarchical tree out of the Concepts, which is recorded in the CONCEPT_ANCESTOR table. For example, "has_ingredient" is a Relationship between Concept of the Concept Class 'Clinical Drug' and those of 'Ingredient', and all Ingredients can be classified as the "parental" hierarchical Concepts for the drug products they are part of. All 'Is a' Relationships are hierarchical.
  * Relationships, also hierarchical, can be between Concepts within the same Vocabulary or those adopted from different Vocabulary sources.
  * In past versions of the RELATIONSHIP table, the relationship_id used to be a numerical value. A conversion table between these old and new IDs is given below:

Previous Relationship_id|Version 5 Relationship_id
:-----------------------|:-----------------------------------
|1|LOINC replaced by|
|2|Has precise ing|
|3|Has tradename|
|4|RxNorm has dose form|
|5|Has form|
|6|RxNorm has ing|
|7|Constitutes|
|8|Contains|
|9|Reformulation of|
|10|Subsumes|
|11|NDFRT has dose form|
|12|Induces|
|13|May diagnose|
|14|Has physio effect|
|15|Has CI physio effect|
|16|NDFRT has ing|
|17|Has CI chem class|
|18|Has MoA|
|19|Has CI MoA|
|20|Has PK|
|21|May treat|
|22|CI to|
|23|May prevent|
|24|Has metabolites|
|25|Has metabolism|
|26|May be inhibited by|
|27|Has chem structure|
|28|NDFRT - RxNorm eq|
|29|Has recipient cat|
|30|Has proc site|
|31|Has priority|
|32|Has pathology|
|33|Has part of|
|34|Has severity|
|35|Has revision status|
|36|Has access|
|37|Has occurrence|
|38|Has method|
|39|Has laterality|
|40|Has interprets|
|41|Has indir morph|
|42|Has indir device|
|43|Has specimen|
|44|Has interpretation|
|45|Has intent|
|46|Has focus|
|47|Has manifestation|
|48|Has active ing|
|49|Has finding site|
|50|Has episodicity|
|51|Has dir subst|
|52|Has dir morph|
|53|Has dir device|
|54|Has component|
|55|Has causative agent|
|56|Has asso morph|
|57|Has asso finding|
|58|Has measurement|
|59|Has property|
|60|Has scale type|
|61|Has time aspect|
|62|Has specimen proc|
|63|Has specimen source|
|64|Has specimen morph|
|65|Has specimen topo|
|66|Has specimen subst|
|67|Has due to|
|68|Has relat context|
|69|Has dose form|
|70|Occurs after|
|71|Has asso proc|
|72|Has dir proc site|
|73|Has indir proc site|
|74|Has proc device|
|75|Has proc morph|
|76|Has finding context|
|77|Has proc context|
|78|Has temporal context|
|79|Findinga sso with|
|80|Has surgical appr|
|81|Using device|
|82|Using energy|
|83|Using subst|
|84|Using acc device|
|85|Has clinical course|
|86|Has route of admin|
|87|Using finding method|
|88|Using finding inform|
|92|ICD9P - SNOMED eq|
|93|CPT4 - SNOMED cat|
|94|CPT4 - SNOMED eq|
|125|MedDRA - SNOMED eq|
|126|Has FDA-appr ind|
|127|Has off-label ind|
|129|Has CI|
|130|ETC - RxNorm|
|131|ATC - RxNorm|
|132|SMQ - MedDRA|
|135|LOINC replaces|
|136|Precise ing of|
|137|Tradename of|
|138|RxNorm dose form of|
|139|Form of|
|140|RxNorm ing of|
|141|Consists of|
|142|Contained in|
|143|Reformulated in|
|144|Is a|
|145|NDFRT dose form of|
|146|Induced by|
|147|Diagnosed through|
|148|Physiol effect by|
|149|CI physiol effect by|
|150|NDFRT ing of|
|151|CI chem class of|
|152|MoA of|
|153|CI MoA of|
|154|PK of|
|155|May be treated by|
|156|CI by|
|157|May be prevented by|
|158|Metabolite of|
|159|Metabolism of|
|160|Inhibits effect|
|161|Chem structure of|
|162|RxNorm - NDFRT eq|
|163|Recipient cat of|
|164|Proc site of|
|165|Priority of|
|166|Pathology of|
|167|Part of|
|168|Severity of|
|169|Revision status of|
|170|Access of|
|171|Occurrence of|
|172|Method of|
|173|Laterality of|
|174|Interprets of|
|175|Indir morph of|
|176|Indir device of|
|177|Specimen of|
|178|Interpretation of|
|179|Intent of|
|180|Focus of|
|181|Manifestation of|
|182|Active ing of|
|183|Finding site of|
|184|Episodicity of|
|185|Dir subst of|
|186|Dir morph of|
|187|Dir device of|
|188|Component of|
|189|Causative agent of|
|190|Asso morph of|
|191|Asso finding of|
|192|Measurement of|
|193|Property of|
|194|Scale type of|
|195|Time aspect of|
|196|Specimen proc of|
|197|Specimen identity of|
|198|Specimen morph of|
|199|Specimen topo of|
|200|Specimen subst of|
|201|Due to of|
|202|Relat context of|
|203|Dose form of|
|204|Occurs before|
|205|Asso proc of|
|206|Dir proc site of|
|207|Indir proc site of|
|208|Proc device of|
|209|Proc morph of|
|210|Finding context of|
|211|Proc context of|
|212|Temporal context of|
|213|Asso with finding|
|214|Surgical appr of|
|215|Device used by|
|216|Energy used by|
|217|subst used by|
|218|Acc device used by|
|219|Clinical course of|
|220|Route of admin of|
|221|Finding method of|
|222|Finding inform of|
|226|SNOMED - ICD9P eq|
|227|SNOMED cat - CPT4|
|228|SNOMED - CPT4 eq|
|239|SNOMED - MedDRA eq|
|240|Is FDA-appr ind of|
|241|Is off-label ind of|
|243|Is CI of|
|244|RxNorm - ETC|
|245|RxNorm - ATC|
|246|MedDRA - SMQ|
|247|Ind/CI - SNOMED|
|248|SNOMED - ind/CI|
|275|Has therap class|
|276|Therap class of|
|277|Drug-drug inter for|
|278|Has drug-drug inter|
|279|Has pharma prep|
|280|Pharma prep in|
|281|Inferred class of|
|282|Has inferred class|
|283|SNOMED proc - HCPCS|
|284|HCPCS - SNOMED proc|
|285|RxNorm - NDFRT name|
|286|NDFRT - RxNorm name|
|287|ETC - RxNorm name|
|288|RxNorm - ETC name|
|289|ATC - RxNorm name|
|290|RxNorm - ATC name|
|291|HOI - SNOMED|
|292|SNOMED - HOI|
|293|DOI - RxNorm|
|294|RxNorm - DOI|
|295|HOI - MedDRA|
|296|MedDRA - HOI|
|297|NUCC - CMS Specialty|
|298|CMS Specialty - NUCC|
|299|DRG - MS-DRG eq|
|300|MS-DRG - DRG eq|
|301|DRG - MDC cat|
|302|MDC cat - DRG|
|303|Visit cat - PoS|
|304|PoS - Visit cat|
|305|VAProd - NDFRT|
|306|NDFRT - VAProd|
|307|VAProd - RxNorm eq|
|308|RxNorm - VAProd eq|
|309|RxNorm replaced by|
|310|RxNorm replaces|
|311|SNOMED replaced by|
|312|SNOMED replaces|
|313|ICD9P replaced by|
|314|ICD9P replaces|
|315|Multilex has ing|
|316|Multilex ing of|
|317|RxNorm - Multilex eq|
|318|Multilex - RxNorm eq|
|319|Multilex ing - class|
|320|Class - Multilex ing|
|321|Maps to|
|322|Mapped from|
|325|Map includes child|
|326|Included in map from|
|327|Map excludes child|
|328|Excluded in map from|
|345|UCUM replaced by|
|346|UCUM replaces|
|347|Concept replaced by|
|348|Concept replaces|
|349|Concept same_as to|
|350|Concept same_as from|
|351|Concept alt_to to|
|352|Concept alt_to from|
|353|Concept poss_eq to|
|354|Concept poss_eq from|
|355|Concept was_a to|
|356|Concept was_a from|
|357|SNOMED meas - HCPCS|
|358|HCPCS - SNOMED meas|
|359|Domain subsumes|
|360|Is domain|