---
output: 
  html_document:
    theme: flatly
---




## Manufacturing Facilities

**FRS - Facility Registry Service:**
The [Facility Registry Service](https://www.epa.gov/frs) (FRS) is a database maintained by the U.S. Environmental Protection Agency (EPA) and serves as a central repository of facilities subject to environmental regulations. The database is updated every 7 days and is publicly available through the FRS website. FRS data used in this application includes name, address, location, and industrial classifications.

**TRI – Toxic Release Inventory:**
The [Toxic Release Inventory](https://www.epa.gov/toxics-release-inventory-tri-program) (TRI) dataset contains information on toxic chemical releases and waste management activities reported by industrial facilities in the United States that are subject to the Emergency Planning and Community Right-to-Know Act section 313(b)(2). The data are collected and maintained by the EPA and publicly available through the TRI program's website. The dataset includes facility information, industrial classifications, chemical information, chemical release information, and chemical transfer information. The data are reported on an annual basis.

**CERS – California Environmental Reporting System:**
The California Environmental Protection Agency (CalEPA) manages the [California Environmental Reporting System](https://cers.calepa.ca.gov/about-cers/) (CERS). CERS is an online reporting system for businesses and local governments to submit information regarding hazardous material regulatory activities, chemical inventories, underground and aboveground storage tanks, and hazardous waste generation. We received this data from CalEPA and utilized facility information, industry classifications, and chemical storage information for this tool.

**EIS – Emissions Inventory System:**
The [Emissions Inventory System](https://www.epa.gov/air-emissions-inventories/emissions-inventory-system-eis-gateway) (EIS) is a national database of reported air emissions that can be accessed by registered EPA, State, local, and Tribal users. This database is not open to the public. We downloaded California EIS data by NAICS codes associated with manufacturers through the EIS Gateway. The data downloaded does not contain chemical information. This database could be used for future research by SCP to identify chemicals emitted from specific facilities. 


## Industry Classification Codes
Industry classification codes are used by reporting systems to classify business activity. We used these codes to determine manufacturers from other types of facilities, and then to identify product categories. 

The North American Industry Classification System (NAICS) codes are the current standardized system used to classify and categorize businesses in the United States, Canada, and Mexico. The system was established by the US Census Bureau in 1997 to replace the outdated Standard Industrial Classification (SIC) system. The primary purpose of NAICS codes is to provide a common language for businesses and government agencies to use for collecting, analyzing, and publishing statistical data. We used NAICS codes beginning with 31-33 to identify manufacturers.

SIC codes were used to classify and categorize businesses in the United States before the NAICS system was introduced in 1997. SIC codes had been in use for 70 years without significant updates. The purpose of SIC codes is the same as of NAICS codes, however the organization is different. SIC codes are still in use due to legacy issues or comparability purposes. While different datasets use different product classification systems, there is clear trend in preferring NAICS over SIC codes. We used SIC codes beginning with 20-39 to identify manufacturers.


## Chemical Information

We used available chemical information from the TRI and CERS datasets utilized for identifying manufacturers in California. We also used data available from Chemical Data Reporting (CDR) from the EPA. This chemical information can be further explored on the “Chemical Data Table” panel.

**TRI - Toxic Release Inventory:**
The Emergency Planning and Community Right-to-Know Act, Section 313 requires EPA to annually collect data on releases and transfer of certain chemicals. The chemicals that are subject to reporting are listed in the EPA list of hazardous TRI chemicals. The chemicals added to TRI inventory are those known to cause one or more of the following:

 * Cancer or other chronic human health effects
 * Significant adverse acute human health effects
 * Significant adverse environmental effects
 
 The full list of chemicals in the TRI inventory can be found [here:](https://www.epa.gov/toxics-release-inventory-tri-program/tri-listed-chemicals).
 
**CERS - California Environmental Reporting System:**
CERS chemical data include up to 75,000 hazardous waste and materials that are reported to the California Unified Program. The chemicals that are reflected in CERS may be found in Unified Program Chemical Library [here:](https://cersbusiness.calepa.ca.gov/public/chemicals/). The data used for this tool are available via the [CalEPA Regulated Site Portal](https://siteportal.calepa.ca.gov/nsite/map/help)

**CDR – Chemical Data Reporting:**
The [Chemical Data Reporting Rule](https://www.epa.gov/sites/default/files/2020-05/documents/fact_sheet_chemical_substances_subject_tsca_actions_05.08.20.pdf) under the Toxic Substances Control Act (TSCA) requires manufacturers to provide information about the chemicals used in commerce. Every four years, the U.S. EPA collects basic information on types of chemicals, their quantities, and uses. Due to multiple TSCA exemptions, not all chemicals that are subject to TSCA must be reported. Manufacturers must report chemicals that are subject to the CDR rule only when production volume exceeds 25,000 lbs per reporting year at a single site and revenue of the parent company exceeds $12 million. There is not a prepared list of TSCA inventory available. 
 
## Disadvantaged Communities
This interactive map tool indicates manufacturing activity that fall within census tracts designated as disadvantaged communities (DACs) by the CalEPA. California Senate Bill 535 (De Leon, 2012) tasked CalEPA with identifying, based on “geographic, socioeconomic, public health, and environmental hazard criteria,” disadvantaged communities that would receive investment proceeds from California’s Cap-and-Trade program established under the California Global Warming Solutions Act of 2006 (Assembly Bill 32, Nunez, 2006). 

These communities are identified using the California Communities Environmental Health Screening Tool (CalEnviroScreen), a mapping tool developed by CalEPA’s Office of Environmental Health Hazard Assessment (OEHHA) that awards a score of environmental pollution burden to each census tract. There are several environmental, health, and socioeconomic variables examined by the tool to determine pollution scores. A census tract with a higher score is one that experiences a higher pollution burden than census tracts with low scores. As of May 2022, DACs are designated by CalEPA under the following conditions utilizing CalEnviroScreen:

 1. Census tracts receiving the highest 25 percent of overall scores in CalEnviroScreen 4.0 (1,984 tracts).
 2. Census tracts lacking overall scores in CalEnviroScreen 4.0 due to data gaps but receiving the highest 5 percent of CalEnviroScreen 4.0 cumulative pollution burden scores (19 tracts).
 3. Census tracts identified in the 2017 DAC designation as disadvantaged, regardless of their scores in CalEnviroScreen 4.0 (307 tracts).
 4. Lands under the control of federally recognized Tribes. 

## Significant Habitats
Sensitive ecosystems are identified in this interactive map using the Significant Habitats datasets from the California Department of Fish & Wildlife’s Areas of Conservation Emphasis research. Both the [Aquatic Significant Habitat](https://nrm.dfg.ca.gov/FileHandler.ashx?DocumentID=150855&inline) and [Terrestrial Significant Habitat](https://nrm.dfg.ca.gov/FileHandler.ashx?DocumentID=150834&inline) datasets are used to determine the likelihood of the presence of habitats that are important to national, state, and local conservation laws. Such habitats could be indicative of species of conservation concern such as anadromous habitat, for example. The information available within these datasets does not replace the need for in situ evaluation and should be further investigated for regulatory purposes.

**Aquatic Significant Habitats:** 
Hydrologic Unit Code (HUC) 12 watersheds across the state are ranked 1-5 based on the number of significant habitat categories present within each watershed. Any HUC 12 watersheds that were unranked (zero score) were removed from the dataset. The nine aquatic significant categories represented are: (1) presence of anadromous habitat, (2) presence of riparian vegetation types, (3) presence of lakes, (4) count of freshwater wetland types, (5) presence of meadow and emergent wetlands, (6) presence of ponds, (7) presence of seeps and springs, (8) presence of vernal ponds, and (9) presence of saline wetlands. For example, a HUC 12 watershed ranked 5 contains at least five of the categories above indicating a higher likelihood of the presence of habitat impacted by conservation laws or the presence of species of conservation concern. Conversely, a HUC 12 watershed ranked 1 contains exactly one of the categories above indicating a lower likelihood of the presence of habitat impacted by conservation laws or the presence of species of conservation concern.

**Terrestrial Significant Habitats:**
This dataset breaks up California into 2.5-mile hexagons, which are ranked 1-5 based on the number of significant habitat categories present within each hex. Any hexagon that was unranked (zero score) was removed from the dataset. The nine terrestrial significant categories represented are: (1) presence of rare vegetation, (2) presence of California oak woodlands, (3) presence of riparian vegetation types, (4) count of freshwater wetland types, (5) presence of meadow and emergent wetlands, (6) presence of ponds, (7) presence of seeps and springs, (8) presence of vernal ponds, and (9) presence of saline wetlands. For example, a hex ranked 5 contains at least five of the categories above indicating a higher likelihood of the presence of habitat impacted by conservation laws or the presence of species of conservation concern. Conversely, a hex ranked 1 contains exactly one of the categories above indicating a lower likelihood of the presence of habitat impacted by conservation laws or the presence of species of conservation concern.



