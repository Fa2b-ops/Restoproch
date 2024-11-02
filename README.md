# RestoProch

RestoProch est une grande chaîne de restauration spécialisée « fast food ». </p>
L’activité principale de cette chaîne vient des commandes à emporter ; RestoProch ne fait pas du tout de commandes sur place. </p>
Pour faire une commande, il faut aller sur leur site Internet, choisir le restaurant et ensuite faire la commande. 
Le client a ensuite un numéro de commande et vient le chercher dans le restaurant choisi.</p>
Le site Internet (font + back + bdd) de cette chaîne est hébergé dans leurs serveurs (on premise). </br>
La performance de ce site est bien de manière générale, mais l’équipe technique a remarqué que dans certaines périodes (fête + vacances), les serveurs ne tiennent pas la charge et rencontrent de vraies difficultés.</br>
Étant donné que ce site fait 100 % de chiffre d’affaires de l’entreprise, chaque heure le site hors ligne coûte à l’entreprise, car le client qui tente deux/trois fois pour faire sa commande abandonne si ça ne marche pas pour un autre restaurant. </p>
Une réunion entre le directeur de l’entreprise, l’architecte technique, les développeurs et les DevOps a eu lieu afin de trouver une solution. Suite à cette réunion, ils ont pris les décisions suivantes :</p>
Recovery time objective (TTO) = H : si l’application est down, la durée maximum autorisée est1 h, et il faut que remonte UP.</br>
Recovery point objective (RPO) = 12H : il faut faire des sauvegardes automatiques toutes les12 h.</p>
Suite à ces décisions, l’architecte a proposé :
- de doubler les serveurs back (qui est en java) et serveurs front en mettant un load balancerpour les deux ;
- un Snapshot automatique de la BDD toutes les 12 h (durée max de chaque snapshot 30 jours) ;
- de mettre une place une application front-end en reactjs qui sera up en cas de perte de frontprincipale.
