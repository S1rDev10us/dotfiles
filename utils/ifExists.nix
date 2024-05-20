{...}: path:
if builtins.pathExists path
then [path]
else []
