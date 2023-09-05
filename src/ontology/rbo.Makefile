## Customize Makefile settings for rbo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


##################### CUSTOM IMPORTS#########

imports/chebi_import.owl: mirror/chebi.owl imports/chebi_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/chebi_terms_combined.txt --force true --method STAR \
			annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/chebi_top_import.owl: mirror/chebi.owl
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< --branch-from-terms imports/chebi_terms_top.txt --force true --method MIREOT \
			annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/chmo_import.owl: mirror/chmo.owl imports/chmo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query  -i $< --update ../sparql/preprocess-module.ru \
		extract -T imports/chmo_terms_combined.txt --force true --copy-ontology-annotations true --individuals exclude --method BOT \
		remove -t "http://purl.obolibrary.org/obo/BFO_0000040" --axioms subclass --trim false --signature true \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/doid_import.owl: 
	if [ $(IMP) = true ]; then cp mirror/doid.owl imports/doid_import.owl; fi

imports/pato_import.owl: mirror/pato.owl imports/pato_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/pato_terms_combined.txt --force true --method BOT \
		remove -t "http://purl.obolibrary.org/obo/BFO_0000023" -t "http://purl.obolibrary.org/obo/CHEBI_50906" --axioms subclass --trim false --signature true \
		remove -t "http://purl.obolibrary.org/obo/BFO_0000023" -t "http://purl.obolibrary.org/obo/CHEBI_50906" --axioms equivalent --trim false --signature true \
		query --update ../sparql/inject-subset-declaration.ru \
			annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi


imports/efo_import.owl: mirror/efo.owl imports/efo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/efo_terms_combined.txt --force true --method BOT \
	remove -t "http://purl.obolibrary.org/obo/RO_0000053" \
	remove -t "http://www.ebi.ac.uk/efo/EFO_0000001" \
	remove -t "http://purl.obolibrary.org/obo/BFO_0000023" -t "http://purl.obolibrary.org/obo/BFO_0000020" --axioms subclass --trim false --signature true \
    query --update ../sparql/inject-subset-declaration.ru \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/envo_import.owl: mirror/envo.owl imports/envo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/envo_terms_combined.txt --force true --method BOT \
		remove -t "https://www.wikidata.org/wiki/Q2306597" \
		remove -t "PO:0007033" -t BFO:0000003 --trim false --axioms subclass --signature true --preserve-structure false \
		remove -t "PO:0025337" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false\
		remove -t "PO:0028002" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false\
		remove -t "PO:0009012" -t BFO:0000015 --trim false --axioms subclass --signature true --preserve-structure false\
		remove -t "ENVO:02500000" -t BFO:0000001 --trim false --axioms subclass --signature true --preserve-structure false\
		remove -t "ENVO:01001174"  --select self --trim true --signature true --preserve-structure false\
		remove -t "http://purl.obolibrary.org/obo/PATO_0001739" -t "IAO:0000115" --axioms annotation --trim false --signature true \
    query --update ../sparql/inject-subset-declaration.ru \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/ncbitaxon_import.owl: mirror/ncbitaxon.owl imports/ncbitaxon_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/ncbitaxon_terms_combined.txt --force true --method BOT \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi

imports/uberon_import.owl: mirror/uberon.owl imports/uberon_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/uberon_terms_combined.txt --force true --method STAR \
		rename --mappings ./imports/rename_uberon.tsv \
		remove -t "http://purl.obolibrary.org/obo/NCBITaxon_Union_0000023" \
    query --update ../sparql/inject-subset-declaration.ru \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
	
imports/cob_import.owl: mirror/cob.owl imports/cob_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/cob_terms_combined.txt --force true --method STAR \
    query --update ../sparql/inject-subset-declaration.ru \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi
	
imports/go_import.owl: mirror/go.owl imports/go_terms_combined.txt
	if [ $(IMP) = true ]; then \
	$(ROBOT) extract -i mirror/go.owl --branch-from-term "obo:GO_0006281"  --force true --method MIREOT --output imports/go_top.tmp.owl && \
	$(ROBOT) query  -i $< --update ../sparql/preprocess-module.ru \
        extract -T imports/go_terms_combined.txt --force true --copy-ontology-annotations true --individuals exclude --method BOT \
        query --update ../sparql/inject-subset-declaration.ru --update ../sparql/postprocess-module.ru \
        annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && \
	$(ROBOT) merge --input $@.tmp.owl --input imports/go_top.tmp.owl && mv $@.tmp.owl $@; fi

imports/uo_import.owl: mirror/uo.owl imports/uo_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) extract -i $< -T imports/uo_terms_combined.txt --force true --method BOT --individuals exclude \
    query --update ../sparql/inject-subset-declaration.ru \
    annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@; fi


#########################################
### Generating all ROBOT templates ######
#########################################

TEMPLATESDIR=../templates

TEMPLATES=$(patsubst %.tsv, $(TEMPLATESDIR)/%.owl, $(notdir $(wildcard $(TEMPLATESDIR)/*.tsv)))

$(TEMPLATESDIR)/%.owl: $(TEMPLATESDIR)/%.tsv $(SRC)
	$(ROBOT) merge -i $(SRC) template --template $< --output $@ && \
	$(ROBOT) annotate --input $@ --ontology-iri $(ONTBASE)/components/$*.owl -o $@
	
components/all_templates.owl: $(TEMPLATES)
	$(ROBOT) merge $(patsubst %, -i %, $^) \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		--output $@.tmp.owl && mv $@.tmp.owl $@
		
templates: $(TEMPLATES)
	echo $(TEMPLATES)
