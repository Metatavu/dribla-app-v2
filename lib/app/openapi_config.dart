// Openapi Generator last run: : 2025-10-23T15:14:15.853
import "package:openapi_generator_annotations/openapi_generator_annotations.dart";

@Openapi(
  inputSpec: InputSpec(path: "./dribla-api-spec/swagger.yaml"),
  generatorName: Generator.dio,
  outputDirectory: "./packages/dribla_api",
  additionalProperties: DioProperties(pubName: "dribla_api"),
)
class OpenApiGeneratorConfig {}