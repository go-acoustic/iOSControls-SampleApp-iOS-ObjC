var reporter = require('cucumber-html-reporter');

var options = {
        theme: 'bootstrap',
        jsonDir: './JsonReports',
        output: './summary_report.html',
        reportSuiteAsScenarios: true,
        launchReport: true,
        metadata: {
            "Test Environment": "STAGING",
            "Browser": "Chrome",
            "Platform": "macOS Sierra",
            "Parallel": "Scenarios",
            "Executed": "Remote"
        }
    };

    reporter.generate(options);
