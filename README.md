Indexes tables in an Azure database if they have a high fragmentation
=====================================================================

            

This runbook indexes all of the tables in a given database if the fragmentation is above a certain percentage. 

This runbook is based on an existing runbook from Azure Automation team, but fixes a bug related to tables contained in schemas other than the default schema
