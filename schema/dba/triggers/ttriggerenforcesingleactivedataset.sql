CREATE TRIGGER ttriggerenforcesingleactivedataset AFTER INSERT OR UPDATE OF isactive ON dba.tdataset FOR EACH ROW WHEN ((new.isactive = true)) EXECUTE FUNCTION dba.fenforcesingleactivedataset()
