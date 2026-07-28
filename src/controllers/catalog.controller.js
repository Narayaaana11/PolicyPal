const fs = require('fs');
const path = require('path');

const getCatalog = (req, res) => {
    try {
        const filePath = path.join(__dirname, '../data/policy_catalog.json');
        const rawData = fs.readFileSync(filePath, 'utf8');
        let policies = JSON.parse(rawData);

        const { search } = req.query;

        if (search) {
            const query = search.toLowerCase();
            policies = policies.filter(p => 
                p.provider.toLowerCase().includes(query) || 
                p.policyName.toLowerCase().includes(query) ||
                p.type.toLowerCase().includes(query)
            );
        }

        res.status(200).json({
            success: true,
            data: policies
        });
    } catch (error) {
        console.error('Error fetching policy catalog:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch policy catalog',
            error: error.message
        });
    }
};

module.exports = {
    getCatalog
};
