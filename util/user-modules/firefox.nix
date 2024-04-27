{pkgs, config, ...}:
{
	programs.firefox = {
		enable = true;
		profiles = {
			default = {
				id = 0;
				isDefault = true;
				name = "default";
				extensions = with pkgs.nur.repos.rycee.firefox-addons; [
					ublock-origin
					lastpass-password-manager
				];
				bookmarks = [
					{name = "Nix"; toolbar = true; bookmarks = [
						{name = "NixOS Search"; url = "https://search.nixos.org/packages"; tags = ["nix" "search"]; }
						{name = "Home-Manager Search"; url = "https://home-manager-options.extranix.com/"; tags = ["nix" "search"];}
						];}
					{name = "Youtube"; toolbar = true; bookmarks = [
						{name = "Youtube"; url = "https://youtube.com"; tags = ["video"]; }
						{name = "Youtube History"; url = "https://youtube.com/feed/history"; tags = ["video"]; }
					];}
					{name = "Fritz"; url = "fritz.box"; tags = ["server" "storage"]; }
					{name = "LotusEaters"; url = "https://lotuseaters.com"; tags = ["podcast" "news" "video"]; }
				];
				settings = {
					"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
					"browser.newtabpage.activity-stream.showSponsored" = false;
					"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
					"browser.newtabpage.activity-stream.system.showSponsored" = false;
					"browser.newtabpage.activity-stream.showRecentSaves" = false;
					"browser.newtabpage.activity-stream.feeds.recommendationprovider" = false;
					"browser.newtab.url" = "https://duckduckgo.com";
				};
				search = {
					default = "DuckDuckGo";
					force = true;
					engines = {
						"Nix Packages" = {
							urls = [{
								template = "https://search.nixos.org/packages";
								params = [
									{ name = "type"; value = "packages"; }
									{ name = "query"; value = "{searchTerms}"; }
								];
							}];

							icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
							definedAliases = [ "@np" ];
						};
						"NixOS Wiki" = {
							urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
							iconUpdateURL = "https://wiki.nixos.org/favicon.png";
							updateInterval = 24 * 60 * 60 * 1000; # every day
							icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
							definedAliases = [ "@nw" ];
						};
						"DuckDuckGo".metaData.alias = "@ddg";
						"Google".metaData.hidden = true;
						"Bing".metaData.hidden = true;
						"eBay".metaData.hidden = true;
						"Wikipedia (en)".metaData.hidden = true;
					};
				};
			};
		};
	};
}
