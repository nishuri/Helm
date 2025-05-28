const pipelineToken = process.env.TOKEN;
const patTokenForFeed = process.env.RENOVATE_TOKEN;

module.exports = {
  platform: "azure",
  onboarding: true,
  endpoint: "https://dev.azure.com/hexagonmi",
  token: pipelineToken,
  lockFileMaintenance: {
    enabled: true
  },
  commitMessageSuffix: "[skip ci]",
  repositories: [
  // "MI-Genesis/GenHexFluidCore",
  // "MI-Genesis/GenHexFluidReactHooks",  
  // "MI-Genesis/GenHexSDCReactDebugger",
  // "MI-Genesis/NexusDeveloperPortal",
  // "MI-Genesis/NexusDriveWebApp",
  // "MI-Genesis/NexusDrive",
  // "MI-Genesis/NexusCLIDrive",
  // "MI-Genesis/NexusSolutionsWorkflow",
  // "MI-Genesis/NexusSolnLayoutOptimization",
  // "MI-Genesis/GenHexStaticDocumentation",
  // "MI-Genesis/NexusDesigner",
  // "MI-Genesis/Nexus3DWhiteboardReactApp",
  // "MI-Genesis/GenHexVisualization",
  // "MI-Genesis/Portal",
  // "MI-Genesis/NexusLandingPage",
  // "MI-Genesis/NexusCoreCreditService",
  "MI-Genesis/NexusCoreFileGatewaySdk",
  // "MI-Genesis/HullLicensingWebService-Nexus",
  // "MI-Genesis/HullLicensingWebService-Samples",
  // "MI-Genesis/ProductionSoftware",
  // "MI-Genesis/NexusFoundation",
  // "MI-Genesis/GenHexMetrologyAssetManager",
  // "MI-Genesis/GenHexMetrologyAssetManagerUI",
  {
    repository: "MI-Genesis/PSWebUI",
    ignorePaths: [
      "*/node_modules/*", 
      "*/bower_components/*",
      "*/apps/*/package.json",
      "*/libs/*/package.json"
    ]
  }
],
  "extends": ["config:best-practices", "group:monorepos"],
  prConcurrentLimit: 10,
  prHourlyLimit: 10,
  hostRules: [
    {
      hostType : "npm",
      matchHost: "pkgs.dev.azure.com",
      username : "apikey",
      password : patTokenForFeed, // Use the variable here
    }
  ],
  
  enabledManagers: ["npm","nuget"],
  defaultRegistryUrls: [
    "https://registry.npmjs.org/",
    "https://pkgs.dev.azure.com/hexagonmi/MI-Genesis/_packaging/NexusPlatform/npm/registry/"
  ],
  packageRules: [
    {
      matchRepositories: [
        // "MI-Genesis/NexusCoreCreditService",
        "MI-Genesis/NexusCoreFileGatewaySdk"
      ],
      enabledManagers: ["npm"],
      matchUpdateTypes: ["minor", "patch"],
      labels: ["Renovate-Dependencies-Update"],
      branchPrefix: "dependencies/",
      commitMessagePrefix: "fix(deps): ",
      prBody: "### Dependency Updates for {{depName}}\n\nThis PR updates {{depName}} to version {{newVersion}}."
    },
    {
      description: "NuGet configuration for ProductionSoftware",
      matchRepositories: ["MI-Genesis/ProductionSoftware"], 
      enabledManagers: ["nuget"],
      registryUrls: [
        "https://api.nuget.org/v3/index.json"
      ]
    },
    {
      description: "npm configuration for PSWebUi and 3DWhiteboard,3DWhiteboard nexus designer",
      matchRepositories: [
        // "MI-Genesis/PSWebUi",
        // "MI-Genesis/Nexus3DWhiteboardReactApp",
        // "MI-Genesis/NexusDesigner",
        // "MI-Genesis/GenHexSDCReactDebugger",
        // "MI-Genesis/NexusDeveloperPortal",
        // "MI-Genesis/NexusDriveWebApp",
        // "MI-Genesis/NexusDrive",
        // "MI-Genesis/NexusCLIDrive",
        // "MI-Genesis/NexusSolutionsWorkflow",
        // "MI-Genesis/NexusSolnLayoutOptimization",
        // "MI-Genesis/GenHexStaticDocumentation",
        // "MI-Genesis/GenHexFluidCore",
        // "MI-Genesis/GenHexFluidReactHooks"  
        ], 
      enabledManagers: ["npm"],
      matchUpdateTypes: ["minor", "patch"],
      labels: ["Renovate-Dependencies-Update"],
      branchPrefix: "dependencies/",
      commitMessagePrefix: "fix(deps): ",
      prBody: "### Dependency Updates for {{depName}}\n\nThis PR updates {{depName}} to version {{newVersion}}.",
      // Optionally override or extend registry settings if necessary:
      registryUrls: [
        "https://registry.npmjs.org/",
        "https://pkgs.dev.azure.com/hexagonmi/MI-Genesis/_packaging/NexusPlatform/npm/registry/"
      ]
    },
    {
      description: "NuGet configuration for MI Nexus Licensing Repos",
      matchRepositories: [
        // "MI-Genesis/HullLicensingWebService-Nexus",
        // "MI-Genesis/HullLicensingWebService-Samples"
      ],
      enabledManagers: ["nuget"],
      registryUrls: [
        "https://api.nuget.org/v3/index.json"
      ]
    },
    {
      description: "Portal, Landing Page and GenHexVisualization",
      matchRepositories: [
        // "MI-Genesis/Portal",
        // "MI-Genesis/NexusLandingPage",
        // "MI-Genesis/GenHexVisualization"
        ],
      enabledManagers: ["yarn"],
      registryUrls: [
        "https://registry.npmjs.org/"
      ]
    },
    {
      description: "Renovate Configuration for MAM Project",
      matchRepositories: [
        // "MI-Genesis/NexusFoundation",
        // "MI-Genesis/GenHexMetrologyAssetManager",
        // "MI-Genesis/GenHexMetrologyAssetManagerUI"
        ],
      enabledManagers: ["npm", "nuget"],
      matchUpdateTypes: ["minor", "patch"],
      labels: ["Renovate-Dependencies-Update"],
      branchPrefix: "dependencies/",
      commitMessagePrefix: "fix(deps): ",
      prBody: "### Dependency Updates for {{depName}}\n\nThis PR updates {{depName}} to version {{newVersion}}.",
      registryUrls: [
        "https://registry.npmjs.org/",
        "https://api.nuget.org/v3/index.json",
        "https://pkgs.dev.azure.com/hexagonmi/MI-Genesis/_packaging/NexusPlatform/npm/registry/"
      ]
    }
  ]
};