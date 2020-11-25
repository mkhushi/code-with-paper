function out = get_config(caseString)
    out = [];
    switch lower(caseString)
     case 'areathresh'
      out.thresh = 500;
    end