function changeDefaultWorkers(numWorkers)

c = parcluster(parallel.defaultClusterProfile);
c.NumWorkers = numWorkers;

end