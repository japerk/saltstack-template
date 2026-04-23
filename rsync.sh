rsync --rsync-path="rsync" -avz pillar root@IP_ADDRESS:/srv
rsync --rsync-path="rsync" -avz salt root@IP_ADDRESS:/srv
# use --delete to remove files that are no longer in the source
# also use --dry-run to see what would be deleted first
# rsync --rsync-path="rsync" -avz --delete --dry-run pillar root@IP_ADDRESS:/srv
