classdef TabManager < handle
%   TABMANAGER - Converts panels into Tab Panes based on tag name convention
%
%   Panels names Tab? (e.g. TabA) are used to position a tabgroup that is then
%   populated with panes from Tab?* (e.g. TabAChild1)    
%
%   Useful with Matlab GUIDE created windows
%
%   GUIDE Usage 
%   1. Create a pane with tag set to Tab? where ? is any letter or number
%      (e.g. TabA).  This main pane should be left empty and determines the size
%      and location of the tab group (uitabgroup)
%   2. Create additional panes with a tag name that starts with the name of
%      the main pane. All other controls should be added to these panes.
%   3. In the Guide generated function xxx_OpeningFcn add the following:
%         handles.tabManager = TabManager( hObject );
%
%   Notes: 
%      1. The panes can all be moved to the same location as long as they are 
%         not placed inside each other.  You can edit the hidden panes by
%         using the "Send to back" option on the GUIDE pop-up menu.
%      2. The pane tag names are sorted alphabetically before the panels
%         are created.  One way of making this more obvious is by inserting 
%         ordering digit(s) in the panel tag names.
%         For example, the panels with the following details:
%
%             Title          Tag
%             ----------------------------------
%             Main           TabA02Main
%             Supplementary  TabA01Supplementary
%
%         will create the Supplementary tab first with the Main tab second.
%      3. Tabs can be selected programmatically by setting the SelectedTab 
%         property of the tab group to the required tab.
%         For example:
%               tabMan = handles.tabManager;
%               tabMan.Handles.TabA.SelectedTab = tabMan.Handles.TabA02Supplementary;
%
%	Date          Version   Author          Notes
%	16/08/2015    1.00      Grant Davidson  Initial release
%   13/03/2016    1.01      Grant Davidson  Added note re Tab ordering
%   4/07/2016     1.02      Grant Davidson  Added note re Tab selection
    
    properties
        GuiFigure
        Handles
    end
    
    properties(Constant,Access='private')
        TabPrefix = 'Tab';
    end
    
    properties(Dependent)
        TabGroups
    end
    
    properties(Hidden)
        TabGroupsInternal
    end
    
    methods(Access=private)
        
        function value = GetAllTabPanelsFieldNames( self )
            fields = fieldnames( self.Handles );
            fieldIndices = strncmp(fields,TabManager.TabPrefix, length(TabManager.TabPrefix));
            value = fields(fieldIndices);            
        end
        
        function tabOwnerPanels = GetTabOwnerPanels( self )
            allTabPanels = self.GetAllTabPanelsFieldNames( );
            owners = find(cellfun( @(panelFieldName) length(panelFieldName) == length(TabManager.TabPrefix) + 1, allTabPanels));
            ownerFields = allTabPanels(owners);
            tabOwnerPanels = zeros(size(owners));
            for fi=1:length(ownerFields)
                tabOwnerPanels(fi) = self.Handles.(ownerFields{fi});
            end                       
        end
    end
    
	methods
        function self = TabManager( guiFigure )
            self.GuiFigure = guiFigure;
            self.Handles = guihandles( self.GuiFigure );
            
            ownerPanels = self.GetTabOwnerPanels( );
            self.TabGroupsInternal = zeros(size(ownerPanels));
            for oi=1:length(ownerPanels)
                panelOwner = ownerPanels(oi);
                panelsForOwner = self.GetTabPanelsForOwner( panelOwner );
                pos = get(panelOwner,'Position');
                units = get(panelOwner,'Units');
                ownerTag = get(panelOwner,'Tag');
                delete(panelOwner);
                tabGroup = uitabgroup('Parent', self.GuiFigure, 'Units', units, 'Position', pos, 'Tag', ownerTag );
                
                for pi=1:length(panelsForOwner)
                    hPanel = panelsForOwner(pi);
                    panelTag = get(hPanel,'Tag');
                    panelTitle = get(hPanel,'Title');
                    if iscell(panelTitle)
                        panelTitle = cell2mat(panelTitle);
                    end
                    tab = uitab('Parent', tabGroup, 'Title', panelTitle);
                    children = get(hPanel,'Children');
                    set(children,'Parent', tab);
                    delete(hPanel);
                    set(tab,'Tag', panelTag );
                    %set(hPanel,'Visible', 'off');
                end               
                self.TabGroupsInternal(oi) = tabGroup;
            end
            
            % Refresh handles (although these currently aren't used outside
            % the constructor)
            self.Handles = guihandles( self.GuiFigure );
        end
                
        function value = get.TabGroups( self )
            value = self.TabGroupsInternal;
        end
	end  
    
    methods(Access=private)
        function value = GetTabPanelsForOwner( self, ownerHandle )
            ownerPrefix = get( ownerHandle, 'Tag' );
            allTabPanels = self.GetAllTabPanelsFieldNames( );
            fieldIndices = strncmp(allTabPanels,ownerPrefix, length(ownerPrefix)) & ~strcmp(allTabPanels,ownerPrefix);
            ownerPanelFieldNames = sort(allTabPanels(fieldIndices));            
            value = zeros(size(ownerPanelFieldNames));
            for fi=1:length(ownerPanelFieldNames)
                value(fi) = self.Handles.(ownerPanelFieldNames{fi});
            end            
        end
    end
    
end

