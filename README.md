# FindManuallyCreatedAcounts

This script searches Microsoft Sentinel for accounts that weren't created by the automation service accounts. Once it finds one it checks the account description in Active Directory (This was required as the description field was not kept in Sentinel) for a ticket number. If it does not find one it will email the account creator and tell them to add it to field
