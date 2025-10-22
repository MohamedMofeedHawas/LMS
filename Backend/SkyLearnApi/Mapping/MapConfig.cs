using Mapster;
using SkyLearnApi.Dtos.Year;
using SkyLearnApi.Entities;

namespace SkyLearnApi.Mappings
{
    public static class MapConfig
    {
        public static void RegisterMappings()
        {
            
            TypeAdapterConfig<YearRequestDto, Year>.NewConfig()
                .IgnoreNullValues(true);

            
            TypeAdapterConfig<Year, YearResponseDto>.NewConfig()
                .Map(dest => dest.DepartmentName, src => src.Department.Name)
                .Map(dest => dest.CreatedBy, src => src.CreatedBy.FullName);
        }
    }
}
