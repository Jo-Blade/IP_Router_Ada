with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Liste_Chainee;

procedure Test_Liste_Chainee is

	package Liste_Chainee_String is
		new Liste_Chainee (T_Element => Unbounded_String);
	use Liste_Chainee_String;


	-- Retourner une chaîne avec des guillemets autour de S
	function Avec_Guillemets (S: Unbounded_String) return String is
	begin
		return '"' & To_String (S) & '"';
	end;

	-- Utiliser & entre String à gauche et String à droite.  Des
	-- guillemets sont ajoutées autour de la Unbounded_String
	-- Il s'agit d'un masquage de l'opérateur `&` défini dans Strings.Unbounded
	function "&" (Left: String; Right: Unbounded_String) return String is
	begin
		return Left & Avec_Guillemets (Right);
	end;


	-- Afficher une String et un entier.
	procedure Afficher (S : in Unbounded_String; N: in Integer) is
	begin
		Put (Avec_Guillemets (S));
		Put (" : ");
		Put (N, 1);
		New_Line;
	end Afficher;

	-- Afficher la Liste.
	procedure Afficher is
		new Pour_Chaque (Afficher);


	Nb_Element : constant Integer := 7;
	Element : constant array (1..Nb_Element) of Unbounded_String
			:= (+"un", +"deux", +"trois", +"quatre", +"cinq",
				+"quatre-vingt-dix-neuf", +"vingt-et-un");
	Inconnu : constant  Unbounded_String := To_Unbounded_String ("Inconnu");



	-- Initialiser l'annuaire avec les Donnees et Element ci-dessus.
	-- Attention, c'est à l'appelant de libérer la mémoire associée en
	-- utilisant Vider.
	-- Si Bavard est vrai, les insertions sont tracées (affichées).
	procedure Construire_Exemple_Sujet (Annuaire : out T_Liste_Chainee; Bavard: Boolean := False) is
	begin
		Initialiser (Annuaire);
		pragma Assert (Est_Vide (Annuaire));
		pragma Assert (Taille (Annuaire) = 0);

		for I in 1..Nb_Element loop
			Enregistrer (Annuaire, Element (I));

			if Bavard then
				Put_Line ("Après insertion de l'element " & Element(I));
				Afficher (Annuaire); New_Line;
			else
				null;
			end if;

			pragma Assert (not Est_Vide (Annuaire));
			pragma Assert (Taille (Annuaire) = I);
			for J in I+1..Nb_Element loop
				pragma Assert (not Est_Presente (Annuaire, Element (J)));
			end loop;

		end loop;
	end Construire_Exemple_Sujet;


	procedure Tester_Exemple_Sujet is
		Annuaire : T_Liste_Chainee;
	begin
		Construire_Exemple_Sujet (Annuaire, True);
		Vider (Annuaire);
	end Tester_Exemple_Sujet;


	-- Tester suppression en commençant par les derniers éléments ajoutés
	procedure Tester_Supprimer_Inverse is
		Annuaire : T_Liste_Chainee;
	begin
		Put_Line ("=== Tester_Supprimer_Inverse..."); New_Line;

		Construire_Exemple_Sujet (Annuaire);

		for I in reverse 1..Nb_Element loop

			Supprimer (Annuaire, Element (I));

			Put_Line ("Après suppression de " & Element (I) & " :");
			Afficher (Annuaire); New_Line;

			for J in 1..I-1 loop
				pragma Assert (Est_Presente (Annuaire, Element (J)));
			end loop;

			for J in I..Nb_Element loop
				pragma Assert (not Est_Presente (Annuaire, Element (J)));
			end loop;
		end loop;

		Vider (Annuaire);
	end Tester_Supprimer_Inverse;


	-- Tester suppression en commençant les les premiers éléments ajoutés
	procedure Tester_Supprimer is
		Annuaire : T_Liste_Chainee;
	begin
		Put_Line ("=== Tester_Supprimer..."); New_Line;

		Construire_Exemple_Sujet (Annuaire);

		for I in 1..Nb_Element loop
			Put_Line ("Suppression de " & Element (I) & " :");

			Supprimer (Annuaire, Element (I));

			Afficher (Annuaire); New_Line;

			for J in 1..I loop
				pragma Assert (not Est_Presente (Annuaire, Element (J)));
			end loop;

			for J in I+1..Nb_Element loop
				pragma Assert (Est_Presente (Annuaire, Element (J)));
			end loop;
		end loop;

		Vider (Annuaire);
	end Tester_Supprimer;


	procedure Tester_Supprimer_Un_Element is

		-- Tester supprimer sur un élément, celui à Indice dans Element.
		procedure Tester_Supprimer_Un_Element (Indice: in Integer) is
			Annuaire : T_Liste_Chainee;
		begin
			Construire_Exemple_Sujet (Annuaire);

			Put_Line ("Suppression de " & Element (Indice) & " :");
			Supprimer (Annuaire, Element (Indice));

			Afficher (Annuaire); New_Line;

			for J in 1..Nb_Element loop
				if J = Indice then
					pragma Assert (not Est_Presente (Annuaire, Element (J)));
				else
					pragma Assert (Est_Presente (Annuaire, Element (J)));
				end if;
			end loop;

			Vider (Annuaire);
		end Tester_Supprimer_Un_Element;

	begin
		Put_Line ("=== Tester_Supprimer_Un_Element..."); New_Line;

		for I in 1..Nb_Element loop
			Tester_Supprimer_Un_Element (I);
		end loop;
	end Tester_Supprimer_Un_Element;


	procedure Tester_Remplacer_Un_Element is

		-- Tester enregistrer sur un élément présent, celui à Indice dans Element.
		procedure Tester_Remplacer_Un_Element (Indice: in Integer; Nouveau: in Integer) is
			Annuaire : T_Liste_Chainee;
		begin
			Construire_Exemple_Sujet (Annuaire);

			Put_Line ("Remplacement de " & Element (Indice)
					& " par " & Integer'Image(Nouveau) & " :");
			enregistrer (Annuaire, Element (Indice), Nouveau);

			Afficher (Annuaire); New_Line;

			for J in 1..Nb_Element loop
				pragma Assert (Est_Presente (Annuaire, Element (J)));
				if J = Indice then
					pragma Assert (La_Donnee (Annuaire, Element (J)) = Nouveau);
				else
					pragma Assert (La_Donnee (Annuaire, Element (J)) = Donnees (J));
				end if;
			end loop;

			Vider (Annuaire);
		end Tester_Remplacer_Un_Element;

	begin
		Put_Line ("=== Tester_Remplacer_Un_Element..."); New_Line;

		for I in 1..Nb_Element loop
			Tester_Remplacer_Un_Element (I, 0);
			null;
		end loop;
	end Tester_Remplacer_Un_Element;


	procedure Tester_Supprimer_Erreur is
		Annuaire : T_Liste_Chainee;
	begin
		begin
			Put_Line ("=== Tester_Supprimer_Erreur..."); New_Line;

			Construire_Exemple_Sujet (Annuaire);
			Supprimer (Annuaire, Inconnu);

		exception
			when others =>
				pragma Assert (False);
		end;
		Vider (Annuaire);
	end Tester_Supprimer_Erreur;


	procedure Tester_La_Donnee_Erreur is
		Annuaire : T_Liste_Chainee;
		Inutile: Integer;
	begin
		begin
			Put_Line ("=== Tester_La_Donnee_Erreur..."); New_Line;

			Construire_Exemple_Sujet (Annuaire);
		exception
			when others =>
				pragma Assert (False);
		end;
		Vider (Annuaire);
	end Tester_La_Donnee_Erreur;


	procedure Tester_Pour_chaque is
		Annuaire : T_Liste_Chainee;

		Somme: Integer;

		procedure Sommer (Element: String) is
		begin
			Put (" + ");
			Put (Element, 2);
			New_Line;

			Somme := Somme + Element;
		end;

		procedure Sommer is
			new Pour_Chaque (Sommer);

	begin
		Put_Line ("=== Tester_Pour_Chaque..."); New_Line;
		Construire_Exemple_Sujet(Annuaire);
		Somme := 0;
		Sommer (Annuaire);
		pragma Assert (Somme = Somme_Donnees);
		Vider(Annuaire);
		New_Line;
	end Tester_Pour_chaque;





	procedure Tester_Pour_chaque_Somme_Len4_Erreur is
		Annuaire : T_Liste_Chainee;

		Somme: Integer;

		procedure Sommer_Len4_Erreur (Element: String) is
			Nouvelle_Exception: Exception;
		begin
			if Length (Element) = 4 then
				Put (" + ");
				Put (Element, 2);
				New_Line;

				Somme := Somme + Element;
			else
				raise Nouvelle_Exception;
			end if;
		end;

		procedure Sommer is
			new Pour_Chaque (Sommer_Len4_Erreur);

	begin
		Put_Line ("=== Tester_Pour_Chaque_Somme_Len4_Erreur..."); New_Line;
		Construire_Exemple_Sujet(Annuaire);
		Somme := 0;
		Sommer (Annuaire);
		pragma Assert (Somme = Somme_Donnees_Len4);
		Vider(Annuaire);
		New_Line;
	end Tester_Pour_chaque_Somme_Len4_Erreur;



begin
	Tester_Exemple_Sujet;
	Tester_Supprimer_Inverse;
	Tester_Supprimer;
	Tester_Supprimer_Un_Element;
	Tester_Remplacer_Un_Element;
	Tester_Supprimer_Erreur;
	Tester_La_Donnee_Erreur;
	Tester_Pour_chaque;
	Tester_Pour_chaque_Somme_Len4_Erreur;
	Put_Line ("Fin des tests : OK.");
end Test_Liste_Chainee;
