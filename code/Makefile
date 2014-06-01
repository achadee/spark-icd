FILES= measures.adb heart.adb impulsegenerator.adb hrm.adb icd.adb

all: src.sum

src.sum: measures/limit.siv
	pogs

#measures/limit.siv is just one file touched for sparksimp
measures/limit.siv: spark.rep
	sparksimp -victor

spark.rep: *.ads *.adb
	spark -i=project.idx -vcg -config_file=spark.cfg -w=spark.wrn $(FILES)

clean:
	rm -f *.ali *.o *.lst *.sli

CLEAN: clean
	rm -rf hrm/ impulsegenerator/ heart/ measures/ closedloop/ icd/
	rm -f code.sum spark.rep
