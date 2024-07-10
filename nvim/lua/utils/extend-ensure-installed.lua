return function(opts, ensure_installed)
	opts.ensure_installed = require("utils.lists").list_extend_uniq(opts.ensure_installed, ensure_installed)
end
