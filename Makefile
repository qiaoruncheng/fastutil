DOCSDIR=doc
APIURL=http://java.sun.com/j2se/1.4/docs/api # External URLs in the docs will point here

.SUFFIXES: .java .class

CSOURCES = $(wildcard */*/*/*/*.c)	# The list of C source files
SOURCES = $(CSOURCES:.c=.java)	# The list of Java generated source files
CLASSES = $(SOURCES:.java=.class)		# The list of respective class files

.PHONY: all clean depend install docs jar tar jsources
.SECONDARY: $(SOURCES)

jar: jsources
	ant dist

tar: jar
	tar zhcvf fastUtil-1.1.tgz fastUtil-1.1/

jsources: $(SOURCES)

clean: 
	@find . -name \*.class -exec rm {} \;  
	@find . -name \*.java~ -exec rm {} \;  
	@find . -name \*.html~ -exec rm {} \;  
	@rm -f */*/*/*/*Set.java */*/*/*/*Map.java */*/*/*/*Collection.java */*/*/*/*Iterator.java
	@rm -f */*/*/*/*.c
	@rm -fr $(DOCSDIR)/*


PACKAGES = it.unimi.dsi.fastUtil

docs: jsources
	-mkdir -p $(DOCSDIR)
	-rm -fr $(DOCSDIR)/*
	javadoc -d $(DOCSDIR)  -windowtitle "fastUtil 1.1" -link $(APIURL) $(PACKAGES)
	chmod -R a+rX $(DOCSDIR)


tags:
	etags gendrivers.sh *.drv it/unimi/dsi/fastUtil/Hash.java

# Implicit rule for making Java class files from Java 
# source files. 
.c.java:
	gcc -I. -DNDEBUG -E -C -P $< > $@
