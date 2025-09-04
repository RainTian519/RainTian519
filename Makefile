DOCSDIR = docs
SRC = src

SCHEMA_DIR = $(SRC)/schema
SCHEMA = $(SCHEMA_DIR)/phq_9.yaml
DOCS_DIR = $(DOCSDIR)/

# --- linkml products --- #
jsonschema: $(SCHEMA)
	gen-json-schema $< > jsonschema/phq_9.json

owl: $(SCHEMA)
	gen-owl $< > temp/phq_9.tmp.ttl 
	src/scripts/pun-annotations-to-ttl.py $< > temp/pun.tmp.ttl 
	robot merge -i temp/phq_9.tmp.ttl -i temp/pun.tmp.ttl -o owl/phq_9.ttl 

## remove products
clean-products:
# don't delete README files
	find jsonschema/ -type f -not -name 'README.md' -delete     
	find jsonld/ -type f -not -name 'README.md' -delete     
	find jsonld-context/ -type f -not -name 'README.md' -delete     
	find shacl/ -type f -not -name 'README.md' -delete     
	find owl/ -type f -not -name 'README.md' -delete     

gendoc:
	@# create target folders
	mkdir -p $(DOCS_DIR)
	mkdir -p docs/images

	@# copy existing markdown files (if they exist)
	@if ls src/docs/*.md 1> /dev/null 2>&1; then cp src/docs/*.md docs/; fi
	@if ls src/docs/images/*.* 1> /dev/null 2>&1; then cp src/docs/images/*.* docs/images/; fi

	@# generate documentation
	gen-doc -d $(DOCS_DIR) $(SCHEMA)


## remove docs
clean-docs:
# don't delete README files
	find docs/ -type f -not -name 'README.md' -delete     
	find docs/images/ -type f -not -name 'README.md' -delete     
