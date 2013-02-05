[models] = multisvm1(TrainingSet,GroupTrain);
[result] = multiclassify( TestSet, models );
