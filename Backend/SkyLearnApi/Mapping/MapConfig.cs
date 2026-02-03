namespace SkyLearnApi.Mappings
{
    public static class MapConfig
    {
        public static void RegisterMappings()
        {
            // Year
            TypeAdapterConfig<YearRequestDto, Year>
                .NewConfig()
                .IgnoreNullValues(true);

            TypeAdapterConfig<Year, YearResponseDto>
                .NewConfig()
                .Map(dest => dest.DepartmentName,
                     src => src.Department != null ? src.Department.Name : string.Empty)
                .Map(dest => dest.CreatedBy,
                     src => src.CreatedBy != null ? src.CreatedBy.FullName : string.Empty);

            // Course
            TypeAdapterConfig<Course, CourseResponseDto>
                .NewConfig()
                .Map(dest => dest.DepartmentName,
                     src => src.Department != null ? src.Department.Name : string.Empty)
                .Map(dest => dest.YearName,
                     src => src.Year != null ? src.Year.Name : string.Empty);
        }
    }
}
