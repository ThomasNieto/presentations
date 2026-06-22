# Building PowerShell Modules with C# - Talk Outline

## MUST-HAVES (Core 35-40 minutes)

- [ ] Opening: Problem statement & value proposition
- [ ] **Audience & Deployment Targets:**
  - [ ] Windows PowerShell 5.1
  - [ ] PowerShell 7
- [ ] **PowerShell Version → .NET Version Mapping (Supported):**
  - [ ] Windows PowerShell 5.1 = .NET Framework 4.8.x
  - [ ] PowerShell 7.4 (LTS) = .NET 8
  - [ ] PowerShell 7.6 (Current) = .NET 10
  - [ ] Why this matters for your module target framework
- [ ] **SDK & Versioning Strategy:**
  - [ ] PowerShell Standard (abstraction layer for broad compatibility)
  - [ ] System.Management.Automation (SMA) - the main namespace for PowerShell types
  - [ ] Microsoft.PowerShell.SDK (for embedding/shipping PowerShell in your .NET application)
  - [ ] Which to choose based on your audience/support matrix
- [ ] Binary module architecture (.dll + .psd1)
- [ ] Basic C# project setup with appropriate NuGet dependency
- [ ] Writing your first cmdlet ([Cmdlet] attribute, Verb-Noun pattern)
- [ ] Cmdlet lifecycle (BeginProcessing, ProcessRecord, EndProcessing)
- [ ] Moving away from Console.WriteLine → PowerShell streams
- [ ] Success stream (WriteObject) - main pattern
  - [ ] Arrays
- [ ] Error stream & terminating errors
- [ ] -WhatIf & -Confirm support (ShouldProcess)
- [ ] Live demo: Building and testing a simple cmdlet
- [ ] Closing recap

## VALUABLE ADD-ONS (Extra 20-30 minutes, if time permits)

- [ ] Cmdlet aliases and parameter aliases
- [ ] Parameter validation attributes & best practices
- [ ] Parameter sets
- [ ] ValueFromPipeline and ValueFromPipelineByPropertyName
- [ ] Warning and Verbose streams
- [ ] Non-terminating errors & error handling patterns
- [ ] Output type attribute
- [ ] **Building & Publishing Help:**
  - [ ] Comment-based help in C# (XML documentation)
  - [ ] MAML help generation
  - [ ] Help file structure in modules
  - [ ] Getting help with `Get-Help` cmdlet
  - [ ] Publishing help with your module
  - [ ] Tools for help generation (PlatyPS)
- [ ] **Wildcards & Path Handling:**
  - [ ] Supporting wildcard patterns in parameters (*, ?, [])
  - [ ] WildcardPattern class for matching
  - [ ] Understanding the PowerShell provider system
  - [ ] Working with paths vs. literal paths
  - [ ] Resolving paths to providers (filesystem, registry, etc.)
  - [ ] Best practices for path-based cmdlets
- [ ] **Target Framework Considerations:**
  - [ ] .NET Framework 4.8.x for Windows PowerShell 5.1 compatibility
  - [ ] .NET 8 or .NET 10 for PowerShell 7+ modules
  - [ ] netstandard2.0 for broader compatibility (trade-offs)
- [ ] Debugging in VS Code
- [ ] Packaging & .psd1 manifest essentials (version targeting & compatibility)
- [ ] Demo #2: A more complex scenario

## OPTIONAL DEEP-DIVES (Only if running 90 min + Q&A buffer)

- [ ] Publishing to PowerShell Gallery
- [ ] Module versioning strategies for cross-version support
- [ ] Signed modules & security
- [ ] Private repository hosting
- [ ] Advanced help scenarios (updatable help, culture-specific help)

## Further Learning & Notes

### Topics to Explore & Mention

- [ ] **Assembly Load Context** - Resolve DLL conflicts
- [ ] **Argument Completers** - Providing tab completion for parameters
- [ ] **Feedback Providers** - Customizing user feedback and suggestions
- [ ] **PowerShell Predictor** - Predictive IntelliSense support
- [ ] **PowerShell Providers** (filesystem and beyond)
  - [ ] Provider cmdlet implementations (Copy-Item, Get-Item, etc.)
  - [ ] Custom provider development
- [ ] **Object Formatting** - .ps1xml format files for custom output views
- [ ] **Type Extensions** - Adding methods and properties to existing types
- [ ] **Progress Reporting** - WriteProgress for long-running operations
- [ ] **Custom Object Types** - PSCustomObject and type names
- [ ] **Output Serialization** - Understanding what can/can't be serialized
- [ ] **Error Action Preferences** - ErrorActionPreference and controlling behavior
- [ ] **Module Initialization** - .psm1 vs .psd1 lifecycle
- [ ] **Security Considerations** - Execution policy, script signing, trusted publishers
- [ ] **Performance & Optimization** - Streaming output, lazy evaluation
- [ ] **Remote Execution** - -ComputerName support patterns
